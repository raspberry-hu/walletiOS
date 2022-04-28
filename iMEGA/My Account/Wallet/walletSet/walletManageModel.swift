// Copyright 2022 Neeva Inc. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import Defaults
import Foundation
import web3swift

public struct OnboardingModel {

    public init() {}

    public func createWallet(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let password = "123"
                let bitsOfEntropy: Int = 128
                let mnemonics = try! BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy)!
//                try? NeevaConstants.cryptoKeychain.set(
//                    mnemonics, key: NeevaConstants.cryptoSecretPhrase)

                let keystore = try! BIP32Keystore(
                    mnemonics: mnemonics,
                    password: password,
                    mnemonicsPassword: "",
                    language: .english)!
//                let name = CryptoConfig.shared.walletName
                let keyData = try! JSONEncoder().encode(keystore.keystoreParams)

                let address = keystore.addresses!.first!.address
//                let wallet = Wallet(address: address, data: keyData, name: name, isHD: true)

                let privateKey = try keystore.UNSAFE_getPrivateKeyData(
                    password: password, account: EthereumAddress(address)!
                ).toHexString()
//                try? NeevaConstants.cryptoKeychain.set(
//                    privateKey, key: NeevaConstants.cryptoPrivateKey)
//                Defaults[.cryptoPublicKey] = wallet.address
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("🔥 Unexpected error: \(error).")
            }
        }
    }

//    public func importWallet(inputPhrase: String, completion: @escaping (Bool) -> Void) {
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                let password = "123"
//                let mnemonics = inputPhrase
//                let keystore = try? BIP32Keystore(
//                    mnemonics: mnemonics,
//                    password: password,
//                    mnemonicsPassword: "",
//                    language: .english)!
//                guard let address = keystore?.addresses?.first?.address,
//                    let account = EthereumAddress(address),
//                    let privateKey = try keystore?.UNSAFE_getPrivateKeyData(
//                        password: password, account: account
//                    ).toHexString()
//                else {
//                    DispatchQueue.main.async {
//                        completion(false)
//                    }
//                    return
//                }
////                Defaults[.cryptoPublicKey] = address
////                try? NeevaConstants.cryptoKeychain.set(
////                    mnemonics, key: NeevaConstants.cryptoSecretPhrase)
////                try? NeevaConstants.cryptoKeychain.set(
////                    privateKey, key: NeevaConstants.cryptoPrivateKey)
//                DispatchQueue.main.async {
//                    completion(true)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(false)
//                }
//                print("🔥 Unexpected error: \(error).")
//            }
//        }
//    }
}
