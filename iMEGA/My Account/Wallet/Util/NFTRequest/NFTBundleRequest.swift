//
//  NFTBundleRequest.swift
//  MegaWalletV3
//
//  Created by hu on 2022/1/4.
//

import Foundation
import Combine
import Alamofire

struct NFTBundleRequestState {
    let postContent: NFTBundleSellRequest
    var publisherDeatil: AnyPublisher<NFTCommonResponse, NFTError> {
        NFTBundleRequest(postContent)
            .mapError { NFTError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    private func NFTBundleRequest(_ NFTBundleRequest: NFTBundleSellRequest) -> Future<NFTCommonResponse, Error>{
        return Future<NFTCommonResponse, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let url = URL(string: "http://47.251.8.183:8655/api/fixSell")!
            let request = AF.request(url, method: .post, parameters: NFTBundleRequest, requestModifier: {$0.timeoutInterval = 180})
            let queue = DispatchQueue(label: "JSONQueue", attributes: .concurrent)
            request.validate()
            request.responseDecodable(queue: queue){ (response: AFDataResponse<NFTCommonResponse>) in
                switch response.result {
                case .success(let sellResponse):
                    promise(.success(sellResponse))
                    break
                case .failure(let error):
                    print("捆绑销售请求失败:\(error)")
                    promise(.failure(error))
                    break
                }
            }
        }
      }
    }
}
