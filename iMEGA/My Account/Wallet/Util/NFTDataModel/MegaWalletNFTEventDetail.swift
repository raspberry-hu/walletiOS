// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let nFTEvent = try? newJSONDecoder().decode(NFTEvent.self, from: jsonData)

import Foundation

// MARK: - NFTEvent
struct NFTEventResponse: Codable {
    let code: Int
    let msg: [Msg]
}

// MARK: - Msg
struct Msg: Codable {
//    let approvedAccount: JSONNull?
//    let asset: Asset
//    let contractAddress, createdDate, eventType: String
    let createdDate, eventType: String
    let fromAccount: Owner?
    let endingPrice, startingPrice, totalPrice: String?
//    let paymentToken: PaymentToken?
//    let seller, toAccount: Owner?
    let toAccount: Owner?
//    let transaction: Transaction?
//    let winnerAccount: Owner?

    enum CodingKeys: String, CodingKey {
//        case approvedAccount = "approved_account"
//        case asset
//        case contractAddress = "contract_address"
        case createdDate = "created_date"
        case eventType = "event_type"
        case fromAccount = "from_account"
        case endingPrice = "ending_price"
        case startingPrice = "starting_price"
        case totalPrice = "total_price"
//        case paymentToken = "payment_token"
//        case seller
        case toAccount = "to_account"
//        case transaction
//        case winnerAccount = "winner_account"
    }
}

// MARK: - Asset
struct NFTAsset: Codable {
    let id: Int
    let tokenID: String
    let numSales: Int
    let backgroundColor: JSONNull?
    let imageURL, imagePreviewURL, imageThumbnailURL: String
    let imageOriginalURL: String
    let animationURL, animationOriginalURL: JSONNull?
    let name, assetDescription: String
    let externalLink: JSONNull?
    let assetContract: AssetContract
    let permalink: String
    let collection: NFTCollection
    let decimals: Int
    let tokenMetadata: String
    let owner: Owner

    enum CodingKeys: String, CodingKey {
        case id
        case tokenID = "token_id"
        case numSales = "num_sales"
        case backgroundColor = "background_color"
        case imageURL = "image_url"
        case imagePreviewURL = "image_preview_url"
        case imageThumbnailURL = "image_thumbnail_url"
        case imageOriginalURL = "image_original_url"
        case animationURL = "animation_url"
        case animationOriginalURL = "animation_original_url"
        case name
        case assetDescription = "description"
        case externalLink = "external_link"
        case assetContract = "asset_contract"
        case permalink, collection, decimals
        case tokenMetadata = "token_metadata"
        case owner
    }
}

// MARK: - AssetContract
struct AssetContract: Codable {
    let address, assetContractType, createdDate, name: String
    let nftVersion: String
    let openseaVersion: JSONNull?
    let owner: Int
    let schemaName, symbol, totalSupply: String
    let assetContractDescription, externalLink, imageURL: JSONNull?
    let defaultToFiat: Bool
    let devBuyerFeeBasisPoints, devSellerFeeBasisPoints: Int
    let onlyProxiedTransfers: Bool
    let openseaBuyerFeeBasisPoints, openseaSellerFeeBasisPoints, buyerFeeBasisPoints, sellerFeeBasisPoints: Int
    let payoutAddress: JSONNull?

    enum CodingKeys: String, CodingKey {
        case address
        case assetContractType = "asset_contract_type"
        case createdDate = "created_date"
        case name
        case nftVersion = "nft_version"
        case openseaVersion = "opensea_version"
        case owner
        case schemaName = "schema_name"
        case symbol
        case totalSupply = "total_supply"
        case assetContractDescription = "description"
        case externalLink = "external_link"
        case imageURL = "image_url"
        case defaultToFiat = "default_to_fiat"
        case devBuyerFeeBasisPoints = "dev_buyer_fee_basis_points"
        case devSellerFeeBasisPoints = "dev_seller_fee_basis_points"
        case onlyProxiedTransfers = "only_proxied_transfers"
        case openseaBuyerFeeBasisPoints = "opensea_buyer_fee_basis_points"
        case openseaSellerFeeBasisPoints = "opensea_seller_fee_basis_points"
        case buyerFeeBasisPoints = "buyer_fee_basis_points"
        case sellerFeeBasisPoints = "seller_fee_basis_points"
        case payoutAddress = "payout_address"
    }
}

// MARK: - Collection
struct NFTCollection: Codable {
    let bannerImageURL, chatURL: JSONNull?
    let createdDate: String
    let defaultToFiat: Bool
    let collectionDescription: JSONNull?
    let devBuyerFeeBasisPoints, devSellerFeeBasisPoints: String
    let discordURL: JSONNull?
    let displayData: DisplayData
    let externalURL: JSONNull?
    let featured: Bool
    let featuredImageURL: JSONNull?
    let hidden: Bool
    let safelistRequestStatus: String
    let imageURL: JSONNull?
    let isSubjectToWhitelist: Bool
    let largeImageURL, mediumUsername: JSONNull?
    let name: String
    let onlyProxiedTransfers: Bool
    let openseaBuyerFeeBasisPoints, openseaSellerFeeBasisPoints: String
    let payoutAddress: JSONNull?
    let requireEmail: Bool
    let shortDescription: JSONNull?
    let slug: String
    let telegramURL, twitterUsername, instagramUsername, wikiURL: JSONNull?

    enum CodingKeys: String, CodingKey {
        case bannerImageURL = "banner_image_url"
        case chatURL = "chat_url"
        case createdDate = "created_date"
        case defaultToFiat = "default_to_fiat"
        case collectionDescription = "description"
        case devBuyerFeeBasisPoints = "dev_buyer_fee_basis_points"
        case devSellerFeeBasisPoints = "dev_seller_fee_basis_points"
        case discordURL = "discord_url"
        case displayData = "display_data"
        case externalURL = "external_url"
        case featured
        case featuredImageURL = "featured_image_url"
        case hidden
        case safelistRequestStatus = "safelist_request_status"
        case imageURL = "image_url"
        case isSubjectToWhitelist = "is_subject_to_whitelist"
        case largeImageURL = "large_image_url"
        case mediumUsername = "medium_username"
        case name
        case onlyProxiedTransfers = "only_proxied_transfers"
        case openseaBuyerFeeBasisPoints = "opensea_buyer_fee_basis_points"
        case openseaSellerFeeBasisPoints = "opensea_seller_fee_basis_points"
        case payoutAddress = "payout_address"
        case requireEmail = "require_email"
        case shortDescription = "short_description"
        case slug
        case telegramURL = "telegram_url"
        case twitterUsername = "twitter_username"
        case instagramUsername = "instagram_username"
        case wikiURL = "wiki_url"
    }
}

// MARK: - DisplayData
struct DisplayData: Codable {
    let cardDisplayStyle: String
    let images: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case cardDisplayStyle = "card_display_style"
        case images
    }
}

// MARK: - Owner
struct Owner: Codable {
    let user: NFTUser?
    let profileImgURL: String
    let address, config: String

    enum CodingKeys: String, CodingKey {
        case user
        case profileImgURL = "profile_img_url"
        case address, config
    }
}

// MARK: - User
struct NFTUser: Codable {
    let username: String?
}

// MARK: - PaymentToken
struct PaymentToken: Codable {
    let id: Int
    let symbol, address: String
    let imageURL: String
    let name: JSONNull?
    let decimals: Int
    let ethPrice, usdPrice: String

    enum CodingKeys: String, CodingKey {
        case id, symbol, address
        case imageURL = "image_url"
        case name, decimals
        case ethPrice = "eth_price"
        case usdPrice = "usd_price"
    }
}

// MARK: - Transaction
struct Transaction: Codable {
    let blockHash, blockNumber: String
    let fromAccount: Owner
    let id: Int
    let timestamp: String
    let toAccount: Owner
    let transactionHash, transactionIndex: String

    enum CodingKeys: String, CodingKey {
        case blockHash = "block_hash"
        case blockNumber = "block_number"
        case fromAccount = "from_account"
        case id, timestamp
        case toAccount = "to_account"
        case transactionHash = "transaction_hash"
        case transactionIndex = "transaction_index"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
