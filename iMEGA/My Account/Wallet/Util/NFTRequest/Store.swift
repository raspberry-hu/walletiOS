//
//  Store.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation
import Combine

@available(iOS 14.0, *)
class Store: ObservableObject {
    @Published var appState = AppState()
    
    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[ACTION]:\(action)")
        #endif
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        if let command = result.1 {
            #if DEBUG
            print("[COMMAND]:\(command)")
            #endif
            command.execute(in: self)
        }
    }
    
    static func reduce(
        state: AppState,
        action: AppAction
    )-> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
//        var vm = CoreDataManager.shared
        switch action {
//        case .cast(let castName, let castNumber, let castDescription, let castSet, let castExternalLink, let castChain):
//            appState.NFTcast.castName = castName
//            appState.NFTcast.castNumber = castNumber
//            appState.NFTcast.castDescription = castDescription
//            appState.NFTcast.castSet = castSet
//            appState.NFTcast.castExternalLink = castExternalLink
//            appState.NFTcast.castChain = castChain
//        case .castNFT(let postContent, let postContentUpload, let postContentImage):
//            if appState.NFTcast.casting {
//                break
//            }
//            appState.NFTcast.casting = true
//            appCommand = CastNFTCommand(postContent: postContent, postContentUpload: postContentUpload, postContentImage: postContentImage)
//        case .castNFTDone(let result):
//            switch result {
//            case .success(let model):
//                print("铸币成功")
//                appState.NFTcast.castingEnd = true
//                if model == 200 {
//                    appState.NFTcast.castDone = true
//                    appState.NFTcast.casting = false
//                } else {
//                    appState.NFTcast.casting = false
//                    appState.NFTcast.castFail = true
//                    break
//                }
//            case .failure(let error):
//                appState.NFTcast.castingEnd = true
//                appState.NFTcast.castFailReason = error.localizedDescription
//                appState.NFTcast.castFail = true
//                appState.NFTcast.casting = false
//                print("铸币失败\(error)")
//            }
        case .coinPriceUpdate(let name):
            appCommand = CoinPriceUpdate(name: name)
        case .coinPriceUpdateDone(let result):
            switch result {
            case .success(let model):
                print("更新价格")
                appState.megaWalletCoin.coinPrice = model
                appState.megaWalletCoin.requesting = true
            case .failure(_):
                print("币价更新失败")
            }
        case .coinDetailUpdate(let name):
            appCommand = CoinDetailUpdate(name: name)
        case .coinDetailUpdateDone(let result):
            switch result {
            case .success(let model):
                print("更新detail")
                appState.megaWalletCoin.coinDetail = model
                appState.megaWalletCoin.requesting = true
            case .failure(_):
                print("虚拟货币信息更新失败")
            }
        case .NFTAssetGet(let address):
            appCommand = NFTAssetGet(address: address)
        case .NFTAssetGetDone(let result):
            switch result {
            case .success(let model):
                appState.NFTAsset.NFTAssetImage = model.msg
                print("获取资产成功\(appState.NFTAsset.NFTAssetImage?.count)")
            case .failure(_):
                print("获取资产失败")
            }
        case .NFTAssetDetailGet(let address, let number):
            appCommand = NFTAssetDetailGetCommand(address: address, number: number)
        case .NFTAssetDetailGetDone(let result):
            switch result {
            case .success(let model):
                appState.NFTAssetDetail.NFTAssetImage = model.msg
            case .failure(_):
                print("获取失败")
            }
        case .NFTSellGet(let postContent):
            appCommand = NFTSellRequestCommand(postContent: postContent)
        case .NFTSellDone(let result):
            switch result {
            case .success(let model):
                print("定价销售成功")
                appState.NFTSell.url = model.msg
                appState.NFTSell.createSuccess = true
            case .failure(_):
                print("定价销售失败")
                appState.NFTSell.createFail = true
            }
        case .NFTEnAuctionGet(let postContent):
            appCommand = NFTEnAuctionRequestCommand(postContent: postContent)
        case .NFTEnAuctionDone(let result):
            switch result {
            case .success(let model):
                print("英式拍卖成功")
                appState.NFTAuction.url = model.msg
                appState.NFTAuction.createSuccess = true
            case .failure(_):
                print("英式拍卖失败")
                appState.NFTAuction.createFail = true
            }
        case .NFTNeAuctionGet(let postContent):
            appCommand = NFTNeAuctionRequestCommand(postContent: postContent)
        case .NFTNeAuctionDone(let result):
            switch result {
            case .success(let model):
                print("荷式拍卖成功")
                appState.NFTAuction.url = model.msg
                appState.NFTAuction.createSuccess = true
            case .failure(_):
                print("荷式拍卖失败")
                appState.NFTAuction.createFail = true
            }
        case .NFTBundleGet(let postContent):
            appCommand = NFTBundleRequestCommand(postContent: postContent)
        case .NFTBundleDone(let result):
            switch result {
            case .success(let model):
                print("捆绑销售成功")
                appState.NFTBundle.url = model.msg
                appState.NFTBundle.createSuccess = true
            case .failure(_):
                print("捆绑销售失败")
                appState.NFTBundle.createFail = true
            }
        case .NFTEventGet(let postContent):
            appCommand = NFTEventRequestCommand(postContent: postContent)
        case .NFTEventGetDone(let result):
            switch result {
            case .success(let model):
                print("获取事件信息成功")
                appState.NFTEvent.NFTEventDetail = model
            case .failure(_):
                print("获取事件信息失败")
            }
        case .NFTAssetTypeChangeRequest(let tokenId, let temp):
            appCommand = NFTAssetTypeChangeCommand(tokenId: tokenId, temp: temp)
        case .NFTAssetTypeChangeRequestDone(let result):
            switch result {
            case .success(_):
                print("资产信息改变成功")
            case .failure(_):
                print("资产信息改变失败")
            }
        }
        return (appState, appCommand)
    }
}

