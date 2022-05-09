//
//  NFTSellRequest.swift
//  MegaWalletV3
//
//  Created by hu on 2022/1/4.
//

import Foundation
import Alamofire
import Combine

struct NFTSellRequestState {
    let postContent: NFTSellRequest
    var publisherDeatil: AnyPublisher<NFTCommonResponse, NFTError> {
        NFTSellRequest(postContent)
            .mapError { NFTError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    private func NFTSellRequest(_ NFTSellRequest: NFTSellRequest) -> Future<NFTCommonResponse, Error>{
        return Future<NFTCommonResponse, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let url = URL(string: "http://47.254.43.21:8655/api/fixSell")!
            let request = AF.request(url, method: .post, parameters: NFTSellRequest, requestModifier: {$0.timeoutInterval = 180})
            let queue = DispatchQueue(label: "JSONQueue", attributes: .concurrent)
            request.validate()
            request.responseDecodable(queue: queue){ (response: AFDataResponse<NFTCommonResponse>) in
                switch response.result {
                case .success(let sellResponse):
                    promise(.success(sellResponse))
                    break
                case .failure(let error):
                    print("定价销售请求失败:\(error)")
                    promise(.failure(error))
                    break
                }
            }
        }
      }
    }
}
