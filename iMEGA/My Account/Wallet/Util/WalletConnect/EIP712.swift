//
//  EIP712.swift
//  MEGA
//
//  Created by raspberry on 2022/5/5.
//  Copyright © 2022 MEGA. All rights reserved.
//

//
//  EIP712.swift
//  WalletConnect
//
//  Created by hu on 2022/04/19.
//

import CryptoSwift
import Foundation
import WalletConnectSwift
import web3swift

extension Request {
    func toEIP712() -> EIP712Request? {
        guard let requestData = jsonString.data(using: .utf8),
            let request = try? JSONDecoder().decode(EIP712Params.self, from: requestData),
            let data = request.params[1].data(using: .utf8),
            let eip712Data = try? JSONDecoder().decode(EIP712Data.self, from: data),
            let dataDict = try? JSONSerialization.jsonObject(with: data, options: [])
                as? [String: Any],
            let messageDict = dataDict["message"] as? [String: Any],
            let domainDict = dataDict["domain"] as? [String: Any]
        else {
            return nil
        }

        return EIP712Request(data: eip712Data, domain: domainDict, message: messageDict)
    }
}

struct EIP712Params: Codable {
    let params: [String]
}

struct EIP712Data: Codable {
    let primaryType: String
    let types: [String: [EIP712Property]]
}

struct EIP712Property: Codable {
    let name: String
    let type: String
}

enum EIP712HashableType: String, CaseIterable, Codable {
    case uint8 = "uint8"
    case uint256 = "uint256"
    case address = "address"
    case bytes = "bytes"
    case bytes32 = "bytes32"
    case string = "string"

    func hash(with value: Any) -> Data {
        switch self {
        case .uint8:
            return ABIEncoder.encodeSingleType(type: .uint(bits: 8), value: value as AnyObject)!
        case .uint256:
            return ABIEncoder.encodeSingleType(type: .uint(bits: 256), value: value as AnyObject)!
        case .address:
            return ABIEncoder.encodeSingleType(type: .address, value: value as AnyObject)!
        case .bytes:
            let data = ABIEncoder.convertToData(value as AnyObject)
            return keccak256(data ?? Data())
        case .string:
            return keccak256(value as? String ?? "")
        case .bytes32:
            return ABIEncoder.encodeSingleType(type: .bytes(length: 32), value: value as AnyObject)!
        }
    }
}

struct EIP712Hashable {
    let name: String
    let typeName: String
    let allTypes: [String: [EIP712Property]]
    let childrenTypes: [EIP712Property]
    let data: [String: Any]

    var hashableChildren: [EIP712Hashable] {
        childrenTypes.compactMap {
            guard let dict = data[$0.name] as? [String: Any], let children = allTypes[$0.type]
            else {
                return nil
            }

            return EIP712Hashable(
                name: $0.name, typeName: $0.type, allTypes: allTypes, childrenTypes: children,
                data: dict)
        }
    }

    var encodedType: String {
        let encodedSelfType =
            self.typeName + "("
            + childrenTypes.map { "\($0.type) \($0.name)" }.joined(separator: ",") + ")"
        let encodedChildrenTypes =
            hashableChildren.map { $0.encodedType }.removeDuplicates().sorted().flatMap { $0 }
        return encodedSelfType + encodedChildrenTypes
    }

    var typehash: Data {
        keccak256(encodedType)
    }

    var hash: Data? {
        var hashArray: [Data] = [self.typehash]
        childrenTypes.forEach { child in
            if let hashableChild = hashableChildren.first(where: { $0.name == child.name }),
                let hash = hashableChild.hash
            {
                hashArray.append(hash)
            } else {
                guard let value = data[child.name],
                    let simpleType = EIP712HashableType(rawValue: child.type)
                else { return }
                hashArray.append(simpleType.hash(with: value))
            }
        }
        if hashArray.count != (childrenTypes.count + 1) { return nil }
        let encoded = hashArray.flatMap { $0.bytes }
        return keccak256(encoded)
    }
}

struct EIP712Request {
    let data: EIP712Data
    let domain: [String: Any]
    let message: [String: Any]
    let hashableDomain: EIP712Hashable
    let hashableMessage: EIP712Hashable

    init(data: EIP712Data, domain: [String: Any], message: [String: Any]) {
        self.data = data
        self.domain = domain
        self.message = message
        self.hashableDomain = EIP712Hashable(
            name: "domain", typeName: "EIP712Domain", allTypes: data.types,
            childrenTypes: data.types["EIP712Domain"]!, data: domain)
        self.hashableMessage = EIP712Hashable(
            name: "message", typeName: data.primaryType, allTypes: data.types,
            childrenTypes: data.types[data.primaryType]!, data: message)
    }

    var hashedData: Data? {
        guard let domainHash = hashableDomain.hash, let messageHash = hashableMessage.hash else {
            return nil
        }

        let data = Data([UInt8(0x19), UInt8(0x01)]) + domainHash + messageHash
        return keccak256(data)
    }
}

// MARK: - keccak256
private func keccak256(_ data: [UInt8]) -> Data {
    Data(SHA3(variant: .keccak256).calculate(for: data))
}

private func keccak256(_ string: String) -> Data {
    keccak256(Array(string.utf8))
}

private func keccak256(_ data: Data) -> Data {
    keccak256(data.bytes)
}

