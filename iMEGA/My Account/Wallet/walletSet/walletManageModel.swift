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
                let password = "12345678"
                let bitsOfEntropy: Int = 128
                let mnemonics = try! BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy)!
                let keystore = try! BIP32Keystore(
                    mnemonics: mnemonics,
                    password: password,
                    mnemonicsPassword: "",
                    language: .english)!
//                let name = Defaults[.walletName].last
                let name = "MegaWallet"
                let keyData = try! JSONEncoder().encode(keystore.keystoreParams)

                let address = keystore.addresses!.first!.address
                let wallet = Wallet(address: address, data: keyData, name: name, isHD: true)

                let privateKey = try keystore.UNSAFE_getPrivateKeyData(
                    password: password, account: EthereumAddress(address)!
                ).toHexString()
                Defaults[.walletAddress].append(address)
                try? MEGAWalletConstants.cryptoKeychain.set(privateKey, key: "privateKey\(address)")
                try? MEGAWalletConstants.cryptoKeychain.set(mnemonics, key: "secretPhrase\(address)")
                print("\(MEGAWalletConstants.cryptoKeychain[string: "secretPhrase\(Defaults[.walletAddress].last)"] ?? "No secretPhase")")
//                print("\(MEGAWalletConstants.cryptoKeychain[string: "secretPhrase\(address)"] ?? "No secretPhase")")
//                print(address)
//                print(Defaults[.walletAddress].last)
//                print(mnemonics)
//                print(MEGAWalletConstants.appGroup)
                Defaults[.cryptoPublicKey] = wallet.address
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("🔥 Unexpected error: \(error).")
            }
        }
    }

    public func importWallet(inputPhrase: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let password = "12345678 "
                let mnemonics = inputPhrase
                let keystore = try? BIP32Keystore(
                    mnemonics: mnemonics,
                    password: password,
                    mnemonicsPassword: "",
                    language: .english)!
                guard let address = keystore?.addresses?.first?.address,
                    let account = EthereumAddress(address),
                    let privateKey = try keystore?.UNSAFE_getPrivateKeyData(
                        password: password, account: account
                    ).toHexString()
                else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                Defaults[.cryptoPublicKey] = address
                Defaults[.walletAddress].append(address)
                try MEGAWalletConstants.cryptoKeychain.set(privateKey, key: "privateKey\(Defaults[.walletAddress].last)")
                try? MEGAWalletConstants.cryptoKeychain.set(mnemonics, key: "secretPhrase\(Defaults[.walletAddress].last)")
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                }
                print("🔥 Unexpected error: \(error).")
            }
        }
    }
}

class walletManage: ObservableObject {
    @Published var walletAddress: [String]
    @Published var walletNowAddress: String
    init() {
        self.walletAddress = Defaults[.walletAddress]
        self.walletNowAddress = Defaults[.walletNowAddress]
        if self.walletNowAddress == nil {
            self.walletNowAddress = walletAddress.first ?? ""
        }
    }
    func walletAddressDelete(address: String) {
        self.walletAddress = self.walletAddress.filter{ $0 != address }
    }
    func viewWalletAddressUpdate() {
        self.walletAddress = Defaults[.walletAddress]
        self.walletNowAddress = Defaults[.walletNowAddress]
    }
    func walletAddressUpdate() {
        let deleteWallet = Set(self.walletAddress).symmetricDifference(Defaults[.walletAddress])
        if(deleteWallet != nil) {
            let deleteWalletAddress = deleteWallet.first
            try? MEGAWalletConstants.cryptoKeychain.remove("privateKey\(deleteWalletAddress)")
            try? MEGAWalletConstants.cryptoKeychain.remove("secretPhrase\(deleteWalletAddress)")
        }
        Defaults[.walletAddress] = self.walletAddress
        Defaults[.walletNowAddress] = self.walletNowAddress
    }
}

