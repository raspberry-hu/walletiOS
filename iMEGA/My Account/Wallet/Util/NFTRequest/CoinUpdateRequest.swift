//
//  CoinUpdateRequest.swift
//  MegaWalletV3
//
//  Created by hu on 2021/12/6.
//

import Foundation
import Alamofire
import Combine

extension Array where Element: Publisher {
    var zipAll: AnyPublisher<[Element.Output], Element.Failure> {
        let initial = Just([Element.Output]())
            .setFailureType(to: Element.Failure.self)
            .eraseToAnyPublisher()
        return reduce(initial) { result, publisher in
            result.zip(publisher) { $0 + [$1] }.eraseToAnyPublisher()
        }
    }
}

struct CoinUpdateRequest {
    let coinName:[String]
    
    var all: AnyPublisher<CoinDetailArray, NFTError> {
        coinName
            .map { CoinDeatilUpdateRequest(coinName: $0).publisherDeatil }
            .zipAll
    }
    
    var publisher: AnyPublisher<CoinPriceArray, NFTError> {
        coinUpdateRequest(name: coinName)
            .mapError { NFTError.networkingFailed($0)}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func coinUpdateRequest(name: [String]) -> Future<CoinPriceArray, Error>{
        print("更新价格\(name)")
        return Future<CoinPriceArray, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 8) {
                let url = URL(string: "https://data.mifengcha.com/api/v3/price")!
                let stringName = name.joined(separator: ",")
                let postContent = CoinRequestPara(api: "O5K33BPHND3BENIQFMRBNWEVA3KUDBMEVXKSL5YD", name: stringName)
                print("打印参数\(postContent)")
                let request = AF.request(url, method: .get, parameters: postContent, requestModifier: {$0.timeoutInterval = 180})
                let queue = DispatchQueue(label: "JSONQueue", attributes: .concurrent)
                request.validate()
                request.responseDecodable(queue: queue){ (response: AFDataResponse<CoinPriceArray>) in
                    switch response.result {
                    case .success(let coinArray):
                        promise(.success(coinArray))
                        break
                    case .failure(let error):
                        print("虚拟货币价格请求失败:\(error)")
                        promise(.failure(error))
                        break
                    }
                }
            }
        }
    }
}
