//
//  MegaNFTDataModel.swift
//  MegaWalletV3
//
//  Created by hu on 2021/11/13.
//

import Foundation
import SwiftUI

//MARK: - 铸币后上传事件请求
struct NFTCastUploadRequest: Codable {
    var name: String
    var description: String
    var number: String
    var descriptionUrl: String
    var set: String
    var tokenId: String?
    var walletAddress: String
    
    private enum CodingKeys: String, CodingKey {
        case tokenId, description
        case name = "nft_name"
        case walletAddress = "walletaddress"
        case descriptionUrl = "external_link"
        case number = "mint_num"
        case set = "input_arr"
    }
}

//MARK: - 铸币上传请求(带图片版本)
struct NFTCastUploadImageRequest {
    let imageName: String
    let image: UIImage
    var NFTCast: NFTCastUploadRequest?
}

//MARK: - 铸币事件请求
struct NFTCastRequest: Codable {
    let network: String
    let ownerAddress: String
    let mintNumber: Int
    
    private enum CodingKeys: String, CodingKey {
        case network
        case ownerAddress = "owner_address"
        case mintNumber = "mint_number"
    }
}

//MARK: - 铸币事件返回解析
struct NFTCastResponse: Codable {
    let code: Int
    let msg: [String]
}

struct NFTCastTokenidResponse: Codable {
    let code: Int
    let msg: String
}

struct NFTAssetTypeChangeResponse: Codable {
    let code: Int
    let msg: String
}

struct NFTCastUploadImageResponse: Codable {
    let code: Int
    let msg: String
}
/*
struct NFTSingleAssetResponse: Codable {
    var code: Int?
    var msg: [singleAssetResponse]?
}

struct singleAssetResponse: Codable {
    var imageUrl: String?
    var name: String?
    var description: String?
    
    private enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case name, description
    }
}
*/
//MARK: - 获取事件返回信息解析
struct NFTGetEventsResponse: Codable {
    let code: Int
    let msg: [NFTGetEventsResponseMsg]?
}

struct NFTGetEventsResponseMsg: Codable {
    public var approvedAccount: String?
    public var eventType: String?
    public var createdDate: String?
    public var fromAccount: String?
    public var toAccount: String?
    public var totalPrice: String?
    
    private enum CodingKeys: String, CodingKey {
        case totalPrice = "total_price"
        case createdDate = "created_date"
        case fromAccount = "from_account"
        case toAccount = "to_account"
        case eventType = "event_type"
        case approvedAccount = "approved_account"
    }
}
//MARK: - 一般返回内容解析
struct NFTCommonResponse: Codable {
    let code: Int
    let msg: String
}
//MARK: - 定价销售请求
struct NFTSellRequest: Codable {
    let network: String
    let ownerAddress: String
    let myMnemonic: String
    let fixPrice: Double
    let tokenId: String
    
    private enum CodingKeys: String, CodingKey {
        case network
        case ownerAddress = "owner_address"
        case myMnemonic = "my_mnemonic"
        case fixPrice = "fix_price"
        case tokenId = "token_id"
    }
}
//MARK: - 荷兰式式拍卖请求
struct NFTNetherlandsAuctionRequest: Codable {
    let network: String
    let ownerAddress: String
    let myMnemonic: String
    let startPrice: Double
    let endPrice: Double
    let expirationTime: Int
    let tokenId: String
    
    private enum CodingKeys: String, CodingKey {
        case network, expirationTime
        case ownerAddress = "owner_address"
        case myMnemonic = "my_mnemonic"
        case startPrice = "start_price"
        case endPrice = "end_price"
        case tokenId = "token_id"
    }
}
//MARK: - 英式拍卖请求
struct NFTEndlandAuctionRequest: Codable {
    let network: String
    let ownerAddress: String
    let myMnemonic: String
    let startPrice: Double
    let expirationTime: Int
    let tokenId: String
    
    private enum CodingKeys: String, CodingKey {
        case network, expirationTime
        case ownerAddress = "owner_address"
        case myMnemonic = "my_mnemonic"
        case startPrice = "start_price"
        case tokenId = "token_id"
    }
}
//MARK: -捆绑销售请求
struct NFTBundleSellRequest: Codable {
    let network: String
    let ownerAddress: String
    let myMnemonic: String
    let bundleName: String
    let bundleDescription: String
    let startPrice: Double
    let expirationTime: Int
    let tokenId: [Int]
    
    private enum CodingKeys: String, CodingKey {
        case network, bundleName, bundleDescription, expirationTime
        case ownerAddress = "owner_address"
        case myMnemonic = "my_mnemonic"
        case startPrice = "start_price"
        case tokenId = "token_id"
    }
}

//MARK: - 获取单个资产信息
struct NFTSingleAssetRequest: Codable {
    let assetContractAddress: String
    let tokenId: Int
    
    private enum CodingKeys: String, CodingKey {
        case assetContractAddress = "asset_contract_address"
        case tokenId = "token_id"
    }
}
/*
struct NFTGetBundlesRequest: Codable {
    let onSale: Bool
    let owner: String
    let assetContractAddress: String
    let tokenId: Int
    let limit: String
    
    private enum CodingKeys: String, CodingKey {
        case owner, limit
        case onSale = "on_sale"
        case assetContractAddress = "asset_contract_address"
        case tokenId = "token_ids"
    }
}
*/
//MARK: - 获取事件信息
struct NFTGetEventsRequest: Codable {
    let assetContractAddress: String
    let accountAddress: String
    let tokenId: Int
    let limit: String
    let onlyOpensea: String
    let eventType: String
    let auctionType: String
    
    private enum CodingKeys: String, CodingKey {
        case limit
        case assetContractAddress = "asset_contract_address"
        case accountAddress = "account_address"
        case tokenId = "token_id"
        case onlyOpensea = "only_opensea"
        case eventType = "event_type"
        case auctionType = "auction_type"
    }
}
//MARK: - 获取资产合约信息
struct NFTGetSingleContract: Codable {
    let assetContractAddress: String
    
    private enum CodingKeys: String, CodingKey {
        case assetContractAddress = "asset_contract_address"
    }
}
//MARK: - 获取后端tokenId
struct NFTGetTokenId: Codable {
}

//MARK: -获取资产信息集合
struct NFTGetAssetImageArrayResponse: Codable {
    let code: Int
    let msg: [NFTGetAssetImageResponse]?
}

//MARK: - 获取资产信息以及tokeID
struct NFTGetAssetImageResponse: Codable {
    let tokenID: Int
    let NFTName: String
    let description: String
    let imageUrl: String
    let descriptionLink: String
    let set: String
    let number: String
    let walletAddress: String
    let orderStatus: Int
    
    private enum CodingKeys: String, CodingKey {
        case description
        case tokenID = "token_id"
        case NFTName = "nft_name"
        case imageUrl = "image"
        case descriptionLink = "external_link"
        case set = "input_arr"
        case number = "mint_num"
        case walletAddress = "walletaddress"
        case orderStatus = "order_status"
    }
}
