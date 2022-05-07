//
//  AppState.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct AppState {
    var NFTcast = NFTCast()
    var tabChange = TabState()
    var walletCreate = WalletCreate()
    var walletImport = WalletImport()
    var megaWalletCoin = MegaWalletCoin()
    var NFTAsset = NFTAsset()
    var NFTSell = NFTSell()
    var NFTAuction = NFTAuction()
    var NFTBundle = NFTBundle()
    var walletExist = walletExist()
    var NFTAssetDetail = NFTAssetDetail()
    var NFTEvent = NFTEvent()
//    var NFTAssetDetailAuction = NFTAssetDetailAuction()
//    var NFTAssetDetailBundle = NFTAssetDetailBundle()
}

extension AppState {
    struct MegaWalletCoin {
        var coinDetail: CoinDetailArray?
        var coinPrice: CoinPriceArray?
        var requesting = false
    }
}

extension AppState {
    struct NFTCast {
        enum CastBehavior: CaseIterable {
             case success, fail
        }
        
        enum PickBlockChain: String, CaseIterable {
             case Polygon = "Polygon"
             case Ethereum = "Ethereum"
             case Rinkeby = "rinkeby"
        }
        
        var castChain = "rinkeby"
        var showAllItems = false
        var casting = false
        var castDone = false
        var castFail = false
        var castName = ""
        var castNumber = ""
        var castingEnd = false
        var castDescription = ""
        var castExternalLink = ""
        var castSet = ""
        var castFailReason = ""
        
        mutating func zero() {
            self.castChain = "rinkeby"
            self.showAllItems = false
            self.casting = false
            self.castDone = false
            self.castFail = false
            self.castFail = false
            self.castName = ""
            self.castNumber = ""
            self.castDescription = ""
            self.castExternalLink = ""
            self.castSet = ""
        }
    }
}

extension AppState {
    struct TabState {
        var tabState = false
    }
}

extension AppState {
    struct WalletCreate {
        var mnemonic = "助记词生成中"
        var create = false
        var walletCreateModel: WalletCreateViewModel?
    }
}

extension AppState {
    struct WalletImport {
        var walletimport = false
        var walletImportModel: WalletImportViewModel?
    }
}

extension AppState {
    struct NFTAsset {
        var NFTAssetImage: [NFTGetAssetImageResponse]?
    }
}

extension AppState {
    struct NFTAssetDetail {
        var NFTAssetImage: [NFTGetAssetImageResponse]?
    }
}

extension AppState {
    struct NFTSell {
        var NFTSellPrice = ""
        var network = "rinkeby"
        var address = UserDefaults.standard.string(forKey: "walletAddress")
        var mnemonic = UserDefaults.standard.string(forKey: "walletMnemonic")
        var url = ""
        var createSuccess = false
        var createFail = false
    }
}

extension AppState {
    struct NFTAuction {
        var temp = "英国式拍卖"
        var address = UserDefaults.standard.string(forKey: "walletAddress")
        var time = Date()
        var tokenID = "0"
        var startPrice = "0.0"
        var endPrice = "0.0"
        var network = "rinkeby"
        var mnemonic = UserDefaults.standard.string(forKey: "walletMnemonic")
        var url = ""
        var createSuccess = false
        var createFail = false
    }
}

extension AppState {
    struct NFTBundle {
        var address = UserDefaults.standard.string(forKey: "walletAddress")
        var time = Date()
        var tokenID = [Int]()
        var bundleName = "0.0"
        var bundleDescription = "0.0"
        var startPrice = "0.0"
        var network = "rinkeby"
        var mnemonic = UserDefaults.standard.string(forKey: "walletMnemonic")
        var url = ""
        var createSuccess = false
        var createFail = false
    }
}

extension AppState {
    struct walletExist {
        var walletExist = false
    }
}

extension AppState {
    struct NFTEvent {
        var NFTEventDetail: NFTEventResponse?
    }
}
