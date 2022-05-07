//
//  AppCommand.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation
import Combine

@available(iOS 14.0, *)
protocol AppCommand {
    func execute(in store: Store)
}

class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}

//struct WalletCreateCommand: AppCommand {
//    let name: String
//    let password: String
//
//    func execute(in store: Store) {
//        let token = SubscriptionToken()
//        WalletCreateRequest(name: name, password: password)
//            .publisher.sink(receiveCompletion: { complete in
//                if case .failure(let error) = complete {
//                    store.dispatch(
//                        .walletCreateDone(result: .failure(error))
//                    )
//                }
//                token.unseal()
//            }, receiveValue: { WalletCreateViewModel in
//                store.dispatch(
//                    .walletCreateDone(result: .success(WalletCreateViewModel))
//                )
//            })
//            .seal(in: token)
//    }
//}

//struct WalletImportCommand: AppCommand {
//    let name: String
//    let password: String
//    let mnemonic: String
//    
//    func execute(in store: Store) {
//        let token = SubscriptionToken()
//        WalletImportRequest(name: name, password: password, mnemonic: mnemonic)
//            .publisher.sink(receiveCompletion: { complete in
//                if case .failure(let error) = complete {
//                    store.dispatch(
//                        .walletImportDone(result: .failure(error))
//                    )
//                }
//                token.unseal()
//            }, receiveValue: { WalletImportViewModel in
//                store.dispatch(
//                    .walletImportDone(result: .success(WalletImportViewModel))
//                )
//            })
//            .seal(in: token)
//    }
//}

@available(iOS 14.0, *)
//struct CastNFTCommand: AppCommand {
//    let postContent: NFTCastRequest
//    let postContentUpload: NFTCastUploadRequest
//    let postContentImage: NFTCastUploadImageRequest
//    
//    func execute(in store: Store) {
//        let token = SubscriptionToken()
//        NFTCastRequestLoad
//            .init(postContent: postContent, postContentUpload: postContentUpload, postContentImage: postContentImage)
//            .publisher
//            .sink(
//                receiveCompletion: { complete in
//                    if case .failure(let error) = complete {
//                        store.dispatch(.castNFTDone(result: .failure(error)))
//                    }
//                    token.unseal()
//                },
//                receiveValue: { value in
//                    store.dispatch(.castNFTDone(result: .success(value!)))
//                }
//            )
//            .seal(in: token)
//    }
//}

@available(iOS 14.0, *)
struct CoinPriceUpdate: AppCommand {
    let name: [String]
    func execute(in store: Store) {
        let token = SubscriptionToken()
        print("appcommand coin name\(name)")
        store.appState.megaWalletCoin.requesting = false
        CoinUpdateRequest
            .init(coinName: name)
            .publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.coinPriceUpdateDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(.coinPriceUpdateDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}
@available(iOS 14.0, *)

struct CoinDetailUpdate: AppCommand {
    let name: [String]
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        store.appState.megaWalletCoin.requesting = false
        CoinUpdateRequest
            .init(coinName: name)
            .all
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.coinDetailUpdateDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(.coinDetailUpdateDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}
@available(iOS 14.0, *)
struct NFTAssetGet: AppCommand {
    let address: String
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        NFTAssetRequest
            .init(address: address)
            .publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.NFTAssetGetDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(.NFTAssetGetDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}

@available(iOS 14.0, *)
struct NFTAssetDetailGetCommand: AppCommand {
    let address: String
    let number: String
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        NFTAssetRequestDetail
            .init(address: address, number: number)
            .publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.NFTAssetDetailGetDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(.NFTAssetDetailGetDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }

}

@available(iOS 14.0, *)
struct NFTEnAuctionRequestCommand: AppCommand {
    let postContent: NFTEndlandAuctionRequest
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        NFTEnAuctionRequestState
            .init(postContent: postContent)
            .publisherDeatil
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.NFTEnAuctionDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(.NFTEnAuctionDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}
@available(iOS 14.0, *)
struct NFTNeAuctionRequestCommand: AppCommand {
    let postContent: NFTNetherlandsAuctionRequest
    
    @available(iOS 14.0, *)
    func execute(in store: Store) {
        let token = SubscriptionToken()
        NFTNeAuctionRequestState
            .init(postContent: postContent)
            .publisherDeatil
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.NFTNeAuctionDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(.NFTEnAuctionDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}

@available(iOS 14.0, *)
struct NFTSellRequestCommand: AppCommand {
    let postContent: NFTSellRequest
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        NFTSellRequestState
            .init(postContent: postContent)
            .publisherDeatil
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.NFTSellDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(.NFTSellDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}
@available(iOS 14.0, *)
struct NFTBundleRequestCommand: AppCommand {
    let postContent: NFTBundleSellRequest
    @available(iOS 14.0, *)
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        NFTBundleRequestState
            .init(postContent: postContent)
            .publisherDeatil
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.NFTBundleDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(.NFTBundleDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}
@available(iOS 14.0, *)
struct NFTEventRequestCommand: AppCommand {
    let postContent: NFTGetEventsRequest
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        NFTEventRequestState
            .init(postContent: postContent)
            .publisherDeatil
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.NFTEventGetDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(.NFTEventGetDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
}
@available(iOS 14.0, *)
struct NFTAssetTypeChangeCommand: AppCommand {
    let tokenId: String
    @available(iOS 14.0, *)
    let temp: String
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        NFTAssetTypeChangeRequest
            .init(tokenId: tokenId, temp: temp)
            .publisher
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.NFTAssetTypeChangeRequestDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(.NFTAssetTypeChangeRequestDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
    
}

