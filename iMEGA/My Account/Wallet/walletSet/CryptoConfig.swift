//
//  CryptoConfig.swift
//  MEGA
//
//  Created by hu on 2022/04/28.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Defaults
import Foundation
import secp256k1
import web3swift

struct Wallet {
    let address: String
    let data: Data
    let name: String
    let isHD: Bool
}

public struct HDKey {
    let name: String?
    let address: String
}

public enum EthNode: String, CaseIterable, Identifiable {
    // real eth network
    case Ethereum
    // testing network
    case Ropsten
    // polygon network
    case Polygon

    public var id: Int {
        switch self {
        case .Ethereum:
            return 1
        case .Ropsten:
            return 3
        case .Polygon:
            return 137
        }
    }

    public static func from(chainID: Int?) -> EthNode {
        return allCases.first(where: { $0.id == chainID }) ?? .Ethereum
    }

    private var configKey: String {
        switch self {
        case .Ethereum:
            return "https://mainnet.infura.io/v3/f0ed4e15298d4dbba744d8472b0f1f01"
        case .Ropsten:
            return "https://ropsten.infura.io/v3/f0ed4e15298d4dbba744d8472b0f1f01"
        case .Polygon:
            return "https://polygon-mainnet.g.alchemy.com/v2/PrtiW3ArB5SPfodgiGYsM-weRlo-TPhZ"
        }
    }

    public var url: URL? {
        URL(string: configKey)
    }

    public var currency: TokenType {
        switch self {
        case .Ethereum:
            return .ether
        case .Ropsten:
            return .ether
        case .Polygon:
            return .maticOnPolygon
        }
    }
}

public enum TransactionAction: String {
    case Receive
    case Send
}

public struct TransactionDetail: Hashable {
    let transactionAction: TransactionAction
    let amountInEther: String
    let oppositeAddress: String
}
