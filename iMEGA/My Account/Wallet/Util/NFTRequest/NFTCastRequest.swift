//
//  NFTCastRequest.swift
//  MegaWalletV3
//
//  Created by hu on 2021/11/28.
//

import Foundation
import Combine
import Alamofire
import SwiftUI
import CoreData
import Network

enum NFTError: Error, Identifiable {
    var id: String { localizedDescription }
    case walletCreateFail
    case walletImportFail
    case backendError
    case coinPriceError
    case coinDetailError
    case assetGetError
    case networkingFailed(Error)
}

extension NFTError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .walletCreateFail: return "钱包创建失败"
        case .walletImportFail: return "钱包导入失败"
        case .backendError: return "后端报错"
        case .coinPriceError: return "获取币价信息失败"
        case .coinDetailError: return "获取货币详情失败"
        case .assetGetError: return "请求资产失败"
        case .networkingFailed(let error): return error.localizedDescription
        }
    }
}


@available(iOS 14.0, *)
struct NFTCastRequestLoad {
    let postContent: NFTCastRequest
    let postContentUpload: NFTCastUploadRequest
    let postContentImage: NFTCastUploadImageRequest
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()

    func encoder(loan: NFTCastUploadRequest) -> String?{
        do  {
            let data: Data = try encoder.encode(loan)
            let json_string = String(data: data, encoding: String.Encoding.utf8) ?? ""
            print(data)
            print(String(data: data, encoding: String.Encoding.utf8) as Any)
            print(loan)
            return json_string
        } catch {
            print(error)
        }
        return nil
    }
    
    var publisher: AnyPublisher<Int?, NFTError> {
        NFTCastPublisher(postContent)
//            .mapError { NFTError.networkingFailed($0) }
            .flatMap { fooArr in
                fooArr.publisher.setFailureType(to: Error.self)
             }
            .mapError { NFTError.networkingFailed($0) }
            .flatMap { letter in
                self.NFTCastGetTokenidPublisher(letter)
            }
            .collect()
            .map {
                let temp = NFTCastUploadRequest(name: postContentUpload.name, description: postContentUpload.description, number: postContentUpload.number, descriptionUrl: postContentUpload.descriptionUrl, set: postContentUpload.set, tokenId: $0.description, walletAddress: postContentUpload.walletAddress)
                let tempImage = NFTCastUploadImageRequest(imageName: postContentImage.imageName, image: postContentImage.image, NFTCast: temp)
                return tempImage
            }
            .flatMap { self.NFTImageUpLoadPublisher($0) }
            .mapError { NFTError.networkingFailed($0)}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func NFTCastPublisher(_ postContent: NFTCastRequest) -> Future<[String], Error>  {
        return Future<[String], Error> { promise in
            let url = URL(string: "http://47.254.43.21:8655/api/mint")!
            let request = AF.request(url, method: .post, parameters: postContent, requestModifier: {$0.timeoutInterval = 180})
            let queue = DispatchQueue(label: "JSONQueue", attributes: .concurrent)
            request.validate()
            request.responseDecodable(queue: queue){ (response: AFDataResponse<NFTCastResponse>) in
                switch response.result {
                case .success(let model):
                    print("铸币请求成功:\(model.msg)")
                    promise(.success(model.msg))
                    break
                case .failure(let error):
                    print("铸币请求失败:\(error)")
                    promise(.failure(error))
                    break
                }
            }
        }
    }
    
    private func NFTCastGetTokenidPublisher(_ getHashString: String) -> AnyPublisher<Int, Never> {
        let url = URL(string: "http://47.251.8.183:8091/api/getTokenId?hash=\(getHashString)")!
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: NFTCastTokenidResponse.self)
            .map {
                print("HashId\($0)")
                return Int($0.value!.msg)!
            }
            .eraseToAnyPublisher()
    }

    
    private func NFTImageUpLoadPublisher(_ postContetImage: NFTCastUploadImageRequest) -> AnyPublisher<Int?, Never> {
        let url = URL(string: "http://10.28.179.235:8090/api/batch")!
        let jsonData = encoder(loan: postContetImage.NFTCast!)!
        let imageData: Data = postContetImage.image.pngData()!
//        let httpHeaders = HTTPHeaders
        return AF.upload(multipartFormData: { Multipart in
            Multipart.append(jsonData.data(using: String.Encoding.utf8)!, withName: "data")
            Multipart.append(imageData, withName: "file", fileName: "\(postContetImage.imageName).jpg", mimeType: "image/png")
        }, to: url, method: .post)
            .validate()
            .publishDecodable(type: NFTCastUploadImageResponse.self)
            .map {
                print("图片返回请求\($0)")
                return $0.value?.code
            }
            .eraseToAnyPublisher()
    }
}
