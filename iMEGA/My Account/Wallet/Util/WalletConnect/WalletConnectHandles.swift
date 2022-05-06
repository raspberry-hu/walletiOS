//
//  WalletConnectHandles.swift
//  MEGA
//
//  Created by raspberry on 2022/5/5.
//  Copyright © 2022 MEGA. All rights reserved.
//

//
//  WalletConnectHandlers.swift
//  WalletConnect
//
//  Created by hu on 2022/04/19.
//

import Foundation
import WalletConnectSwift
import web3swift

public protocol ResponseRelay {
    var publicAddress: String { get }
    func send(_ response: Response)
    func askToSign(
        request: Request, message: String, typedData: Bool, sign: @escaping (EthNode) -> String)
    func askToTransact(
        request: Request,
        options: TransactionOptions,
        transaction: EthereumTransaction,
        transact: @escaping (EthNode) -> String
    )
    func send(
        on chain: EthNode,
        transactionData: TransactionData
    ) throws -> String
    func sign(on chain: EthNode, message: String) throws -> String
    func sign(on chain: EthNode, message: Data) throws -> String
}

extension Response {
    public static func signature(_ signature: String, for request: Request) -> Response {
        return try! Response(url: request.url, value: signature, id: request.id!)
    }

    public static func transaction(_ transaction: String, for request: Request) -> Response {
        return try! Response(url: request.url, value: transaction, id: request.id!)
    }
}

public class PersonalSignHandler: RequestHandler {
    let relay: ResponseRelay

    public init(relay: ResponseRelay) {
        self.relay = relay
    }

    public func canHandle(request: Request) -> Bool {
        return request.method == "personal_sign"
    }

    public func handle(request: Request) {
        do {
            let messageBytes = try request.parameter(of: String.self, at: 0)
            let address = try request.parameter(of: String.self, at: 1)

            // Match only the address not the checksum (OpenSea sends them always lowercased :( )
            guard address.lowercased() == relay.publicAddress.lowercased() else {
                relay.send(.reject(request))
                return
            }

            let message = String(data: Data.fromHex(messageBytes) ?? Data(), encoding: .utf8) ?? ""

            relay.askToSign(request: request, message: message, typedData: false) { ethNode in
                return
                    (try? self.relay.sign(
                        on: ethNode, message: messageBytes))
                    ?? ""
            }
        } catch {
            relay.send(.invalid(request))
            return
        }
    }
}

public class SendTransactionHandler: RequestHandler {
    let relay: ResponseRelay

    public init(relay: ResponseRelay) {
        self.relay = relay
    }

    public func canHandle(request: Request) -> Bool {
        return request.method == "eth_sendTransaction"
    }

    public func handle(request: Request) {
        guard let requestData = request.jsonString.data(using: .utf8),
            let transactionRequest = try? JSONDecoder().decode(
                TransactionRequest.self, from: requestData),
            let transactionData = transactionRequest.params.first,
            let transaction = transactionData.ethereumTransaction,
            let _ = EthereumAddress(transactionData.from)
        else {
            relay.send(.invalid(request))
            return
        }

        relay.askToTransact(
            request: request,
            options: transactionData.transactionOptions,
            transaction: transaction
        ) { ethNode in
            return
                (try? self.relay.send(
                    on: ethNode,
                    transactionData: transactionData
                )) ?? ""
        }
    }
}

public class SignTypedDataHandler: RequestHandler {
    let relay: ResponseRelay

    public init(relay: ResponseRelay) {
        self.relay = relay
    }

    public func canHandle(request: Request) -> Bool {
        return request.method == "eth_signTypedData"
    }

    public func handle(request: Request) {
        guard let eip712 = request.toEIP712(),
            let typedData = eip712.hashedData
        else {
            relay.send(.invalid(request))
            return
        }

        relay.askToSign(request: request, message: (eip712.message.description), typedData: true) {
            chain in
            (try? self.relay.sign(on: chain, message: typedData)) ?? ""
        }
    }
}

