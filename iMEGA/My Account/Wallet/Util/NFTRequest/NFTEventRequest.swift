//
//  NFTEventRequest.swift
//  MegaWalletV3
//
//  Created by hu on 2022/01/13.
//

import Foundation
import Alamofire
import Combine

struct NFTEventRequestState {
    let postContent: NFTGetEventsRequest
    var publisherDeatil: AnyPublisher<NFTEventResponse, NFTError> {
        NFTEventRequest(postContent)
            .mapError { NFTError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    private func NFTEventRequest(_ NFTSellRequest: NFTGetEventsRequest) -> Future<NFTEventResponse, Error>{
        return Future<NFTEventResponse, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let url = URL(string: "http://47.254.43.21:8655/api/getEvents")!
            let request = AF.request(url, method: .post, parameters: NFTSellRequest, requestModifier: {$0.timeoutInterval = 180})
            let queue = DispatchQueue(label: "JSONQueue", attributes: .concurrent)
            request.validate()
            request.responseDecodable(queue: queue){ (response: AFDataResponse<NFTEventResponse>) in
                switch response.result {
                case .success(let sellResponse):
                    promise(.success(sellResponse))
                    break
                case .failure(let error):
                    print("获取事件信息请求失败:\(error)")
                    promise(.failure(error))
                    break
                }
            }
        }
      }
    }
}
