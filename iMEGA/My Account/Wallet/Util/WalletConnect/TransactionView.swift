//
//  TransactionView.swift
//  MEGA
//
//  Created by raspberry on 2022/5/5.
//  Copyright © 2022 MEGA. All rights reserved.
//

//
//  TransactionView.swift
//  WalletConnect
//
//  Created by hu on 2022/04/19.
//

import LocalAuthentication
import SDWebImageSwiftUI
import SwiftUI
import WalletConnectSwift
import web3swift

public enum SequenceType: String {
    case sessionRequest
    case personalSign
    case signTypedData
    case sendTransaction
}

public struct SequenceInfo {
    public let type: SequenceType
    public let thumbnailURL: URL
    public let dAppMeta: Session.ClientMeta
    public let chain: EthNode
    public let message: String
    public let onAccept: (Int) -> Void
    public let onReject: () -> Void
    public var transaction: EthereumTransaction? = nil
    public var options: TransactionOptions? = nil

    public init(
        type: SequenceType, thumbnailURL: URL, dAppMeta: Session.ClientMeta, chain: EthNode,
        message: String, onAccept: @escaping (Int) -> Void, onReject: @escaping () -> Void,
        transaction: EthereumTransaction? = nil, options: TransactionOptions? = nil
    ) {
        self.type = type
        self.thumbnailURL = thumbnailURL
        self.dAppMeta = dAppMeta
        self.chain = chain
        self.message = message
        self.onAccept = onAccept
        self.onReject = onReject
        self.transaction = transaction
        self.options = options
    }
}

