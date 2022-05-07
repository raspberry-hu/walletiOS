//
//  AppAction.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation

enum AppAction {
//    case cast(castName: String, castNumber: String, castDescription: String, castSet: String, castExternalLink: String, castChain: String)
//    case walletCreate(name: String, password: String)
//    case walletImport(name: String, password: String, mnemonic: String)
//    case walletCreateDone(result: Result<WalletCreateViewModel, NFTError>)
//    case walletImportDone(result: Result<WalletImportViewModel, NFTError>)
//    case castNFT(postContent: NFTCastRequest, postContentUpload: NFTCastUploadRequest, postConetntImage: NFTCastUploadImageRequest)
//    case castNFTDone(result: Result<Int, NFTError>)
    case coinPriceUpdate(name: [String])
    case coinPriceUpdateDone(result: Result<CoinPriceArray, NFTError>)
    case coinDetailUpdate(name: [String])
    case coinDetailUpdateDone(result: Result<CoinDetailArray, NFTError>)
    case NFTAssetGet(address: String)
    case NFTAssetGetDone(result: Result<NFTGetAssetImageArrayResponse, NFTError>)
    case NFTEnAuctionGet(postContent: NFTEndlandAuctionRequest)
    case NFTEnAuctionDone(result: Result<NFTCommonResponse, NFTError>)
    case NFTNeAuctionGet(postContent: NFTNetherlandsAuctionRequest)
    case NFTNeAuctionDone(result: Result<NFTCommonResponse, NFTError>)
    case NFTSellGet(postContent: NFTSellRequest)
    case NFTSellDone(result: Result<NFTCommonResponse, NFTError>)
    case NFTBundleGet(postContent: NFTBundleSellRequest)
    case NFTBundleDone(result: Result<NFTCommonResponse, NFTError>)
    case NFTAssetDetailGet(address: String, number: String)
    case NFTAssetDetailGetDone(result: Result<NFTGetAssetImageArrayResponse, NFTError>)
    case NFTEventGet(postContent: NFTGetEventsRequest)
    case NFTEventGetDone(result: Result<NFTEventResponse, NFTError>)
    case NFTAssetTypeChangeRequest(tokenId: String, temp: String)
    case NFTAssetTypeChangeRequestDone(result: Result<NFTAssetTypeChangeResponse, NFTError>)
}

