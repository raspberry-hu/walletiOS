//
//  CoinDetailUpdateRequest.swift
//  MegaWalletV3
//
//  Created by hu on 2021/12/8.
//

import Foundation
import Combine
import Alamofire

struct CoinDeatilUpdateRequest {
    
    let coinName: String
    
    var publisherDeatil: AnyPublisher<CoinDetail, NFTError> {
        coinDeatilRequest(coinName)
            .mapError { NFTError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func coinDeatilRequest(_ coinName: String) -> Future<CoinDetail, Error>{
        print("更新币种信息")
        return Future<CoinDetail, Error> { promise in
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let url = URL(string: "https://data.mifengcha.com/api/v3/symbols/\(coinName)")!
            let postContent = CoinDeatilRequestPara(api: "O5K33BPHND3BENIQFMRBNWEVA3KUDBMEVXKSL5YD")
            let request = AF.request(url, method: .get, parameters: postContent, requestModifier: {$0.timeoutInterval = 180})
            let queue = DispatchQueue(label: "JSONQueue", attributes: .concurrent)
            request.validate()
            request.responseDecodable(queue: queue){ (response: AFDataResponse<CoinDetail>) in
                switch response.result {
                case .success(let CoinDetail):
                    promise(.success(CoinDetail))
                    break
                case .failure(let error):
                    print("虚拟货币信息请求失败:\(error)")
                    promise(.failure(error))
                    break
                }
            }
        }
      }
    }
}
