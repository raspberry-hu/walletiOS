//
//  MegaWalletCoinItemViewModel.swift
//  MegaWalletV3
//
//  Created by hu on 2021/11/22.
//

import Foundation
import SwiftUI

//struct MegaWalletCoinItemViewModel {
//    let name: String
//    let value: Double
//    let change: Double
//    let count: Double
//    let image: Image
//    let abbreviation: String
//    let coinPrice: CoinPrice
//    let coinDetail: CoinDetail
//}

//struct NFTSell1Request: Codable {
//    let network: String
//    let ownerAddress: String
//    let myMnemonic: String
//    let fixPrice: Int
//    let tokenId: String
//
//    private enum CodingKeys: String, CodingKey {
//        case network
//        case ownerAddress = "owner_address"
//        case myMnemonic = "my_mnemonic"
//        case fixPrice = "fix_price"
//        case tokenId = "token_id"
//    }
//}

struct CoinRequestPara: Codable {
    let api: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case api = "api_key"
        case name = "slug"
    }
}

struct CoinDeatilRequestPara: Codable {
    let api: String
    
    private enum CodingKeys: String, CodingKey {
        case api = "api_key"
    }
}

typealias CoinPriceArray = [CoinPrice]

struct CoinPrice: Codable {
    let coinPriceName, coinPriceNamesAbb: String?
    let t: Int?
    let u, b, a, v, ra, rv, m, c, h, l, cw, hw, lw, cm, hm, lm, ha, la: Double?

    enum CodingKeys: String, CodingKey {
        case coinPriceName = "s"
        case coinPriceNamesAbb = "S"
        case t = "T"
        case u, b, a, v, ra, rv, m, c, h, l, cw, hw, lw, cm, hm, lm, ha, la
    }
}

typealias CoinDetailArray = [CoinDetail]

struct CoinDetail: Codable {
    let logoURL: String?
    let rank: Int?
    let volumeUsd, marketCapUsd, availableSupply, totalSupply: Double?
    let maxSupply: Double?
    let priceStartAt: Int?
    let explorerUrls: String?
    let whitePaperUrls: String?
    let githubID, twitterID, facebookID: String?
    let redditID: String?
    let proof: String?
    let contractAddress: String?
    let ignore, fiat: Bool?
    let status: String?
    let slug, symbol, fullname: String?
    let websiteURL: String?

    enum CodingKeys: String, CodingKey {
        case logoURL = "logoUrl"
        case rank, volumeUsd, marketCapUsd, availableSupply, totalSupply, maxSupply, priceStartAt, explorerUrls, whitePaperUrls
        case githubID = "githubId"
        case twitterID = "twitterId"
        case facebookID = "facebookId"
        case redditID = "redditId"
        case proof, contractAddress, ignore, fiat, status, slug, symbol, fullname
        case websiteURL = "websiteUrl"
    }
}

//let bitCoin = MegaWalletCoinItemViewModel(name: "BitCoin", value: 42768.31, change: 2.4, count: 0.01, image: Image("BitCoin"), abbreviation: "Bit")
//let ethCoin = MegaWalletCoinItemViewModel(name: "Ethereum", value: 4788.91, change: 3.5, count: 0.3, image: Image("ETH"), abbreviation: "ETH")
//let dogCoin = MegaWalletCoinItemViewModel(name: "DogeCoin", value: 0.37, change: -4.5, count: 40, image: Image("DogeCoin"), abbreviation: "Dog")
