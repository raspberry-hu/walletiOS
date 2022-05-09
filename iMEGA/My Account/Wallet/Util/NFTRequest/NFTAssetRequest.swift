//
//  NFTAssetRequest.swift
//  MegaWalletV3
//
//  Created by hu on 2021/12/9.
//

import Foundation
import Alamofire
import Combine

struct NFTAssetRequest {
    
    let address: String
    var publisher: AnyPublisher<NFTGetAssetImageArrayResponse, NFTError> {
        NFTAssetPublisher(address)
            .mapError { _ in NFTError.assetGetError }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func NFTAssetPublisher(_ address: String) -> Future<NFTGetAssetImageArrayResponse, Error>  {
        return Future<NFTGetAssetImageArrayResponse, Error> { promise in
            let url = URL(string: "http://47.254.43.21:8090/api/detailList/\(address)")!
            let request = AF.request(url, method: .get, requestModifier: {$0.timeoutInterval = 180})
            let queue = DispatchQueue(label: "JSONQueue", attributes: .concurrent)
            request.validate()
            request.responseDecodable(queue: queue){ (response: AFDataResponse<NFTGetAssetImageArrayResponse>) in
                switch response.result {
                case .success(let model):
                    print("读取资产请求成功:\(model.code)")
                    promise(.success(model))
                    break
                case .failure(let error):
                    print("读取资产请求失败:\(error)")
                    promise(.failure(error))
                    break
                }
            }
        }
    }
}

struct NFTAssetRequestDetail {
    
    let address: String
    let number: String
    var publisher: AnyPublisher<NFTGetAssetImageArrayResponse, NFTError> {
        NFTAssetPublisher(address)
            .mapError { _ in NFTError.assetGetError }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func NFTAssetPublisher(_ address: String) -> Future<NFTGetAssetImageArrayResponse, Error>  {
        return Future<NFTGetAssetImageArrayResponse, Error> { promise in
            let url = URL(string: "http://47.254.43.21:8090/api/checktype?type=\(number)&address=\(address)")!
            let request = AF.request(url, method: .get, requestModifier: {$0.timeoutInterval = 180})
            let queue = DispatchQueue(label: "JSONQueue", attributes: .concurrent)
            request.validate()
            request.responseDecodable(queue: queue){ (response: AFDataResponse<NFTGetAssetImageArrayResponse>) in
                switch response.result {
                case .success(let model):
                    print("读取资产细分\(number)请求成功:\(model.code)")
                    promise(.success(model))
                    break
                case .failure(let error):
                    print("读取资产\(number)请求失败:\(error)")
                    promise(.failure(error))
                    break
                }
            }
        }
    }
}
