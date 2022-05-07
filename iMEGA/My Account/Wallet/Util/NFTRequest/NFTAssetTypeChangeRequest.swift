//
//  NFTAssetTypeChangeRequest.swift
//  MegaWalletV3
//
//  Created by hu on 2022/01/15.
//

import Foundation
import Alamofire
import Combine

struct NFTAssetTypeChangeRequest {
    
    let tokenId: String
    let temp: String
    var publisher: AnyPublisher<NFTAssetTypeChangeResponse, NFTError> {
        NFTAssetTypeChangePublisher(temp, tokenId)
            .mapError { _ in NFTError.assetGetError }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func NFTAssetTypeChangePublisher(_ temp: String, _ tokenId: String) -> Future<NFTAssetTypeChangeResponse, Error>  {
        return Future<NFTAssetTypeChangeResponse, Error> { promise in
            let url = URL(string: "http://47.251.8.183:8090/api/updatetype?type=\(temp)&tokenId=\(tokenId)")!
            let request = AF.request(url, method: .get, requestModifier: {$0.timeoutInterval = 180})
            let queue = DispatchQueue(label: "JSONQueue", attributes: .concurrent)
            request.validate()
            request.responseDecodable(queue: queue){ (response: AFDataResponse<NFTAssetTypeChangeResponse>) in
                switch response.result {
                case .success(let model):
                    print("修改资产状态请求成功:\(model.code)")
                    promise(.success(model))
                    break
                case .failure(let error):
                    print("修改资产状态请求失败:\(error)")
                    promise(.failure(error))
                    break
                }
            }
        }
    }
}
