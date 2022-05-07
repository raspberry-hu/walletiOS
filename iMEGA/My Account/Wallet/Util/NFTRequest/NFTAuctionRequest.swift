//
//  NFTAuctionRequest.swift
//  MegaWalletV3
//
//  Created by hu on 2022/1/4.
//

import Foundation
import Combine
import Alamofire

struct NFTEnAuctionRequestState {
    let postContent: NFTEndlandAuctionRequest
    var publisherDeatil: AnyPublisher<NFTCommonResponse, NFTError> {
        NFTAuctionRequest(postContent)
            .mapError { NFTError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    private func NFTAuctionRequest(_ NFTEndlandAuctionRequest: NFTEndlandAuctionRequest) -> Future<NFTCommonResponse, Error>{
        return Future<NFTCommonResponse, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let url = URL(string: "http://47.251.8.183:8655/api/enAuction")!
            let request = AF.request(url, method: .post, parameters: NFTEndlandAuctionRequest, requestModifier: {$0.timeoutInterval = 180})
            let queue = DispatchQueue(label: "JSONQueue", attributes: .concurrent)
            request.validate()
            request.responseDecodable(queue: queue){ (response: AFDataResponse<NFTCommonResponse>) in
                switch response.result {
                case .success(let AuctionResponse):
                    promise(.success(AuctionResponse))
                    break
                case .failure(let error):
                    print("英式拍卖请求失败:\(error)")
                    promise(.failure(error))
                    break
                }
            }
        }
      }
    }
}

struct NFTNeAuctionRequestState {
    let postContent: NFTNetherlandsAuctionRequest
    var publisherDeatil: AnyPublisher<NFTCommonResponse, NFTError> {
        NFTAuctionRequest(postContent)
            .mapError { NFTError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    private func NFTAuctionRequest(_ NFTEndlandAuctionRequest: NFTNetherlandsAuctionRequest) -> Future<NFTCommonResponse, Error>{
        return Future<NFTCommonResponse, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let url = URL(string: "http://47.251.8.183:8655/api/enAuction")!
            let request = AF.request(url, method: .post, parameters: NFTEndlandAuctionRequest, requestModifier: {$0.timeoutInterval = 180})
            let queue = DispatchQueue(label: "JSONQueue", attributes: .concurrent)
            request.validate()
            request.responseDecodable(queue: queue){ (response: AFDataResponse<NFTCommonResponse>) in
                switch response.result {
                case .success(let AuctionResponse):
                    promise(.success(AuctionResponse))
                    break
                case .failure(let error):
                    print("英式拍卖请求失败:\(error)")
                    promise(.failure(error))
                    break
                }
            }
        }
      }
    }
}
