//
//  Web3Model.swift
//  MEGA
//
//  Created by raspberry on 2022/4/29.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation
import SwiftUI
import Defaults
import web3swift

class WalletDetailsModel: ObservableObject {
    @Published var walletName: String = ""
    @Published var walletPassword: String = ""
    @Published var walletSetDone = false
}

class Web3Model: ObservableObject {
    @Published var walletDetailsModel: WalletDetailsModel = WalletDetailsModel()
    var wallet: WalletAccessor?
    var publicAddress: String {
        wallet?.publicAddress ?? ""
    }
    var balances: [TokenType: String?] = [
        .ether: nil, .wrappedEther: nil, .matic: nil, .usdc: nil, .usdt: nil, .shib: nil,
        .wrappedEtherOnPolygon: nil, .maticOnPolygon: nil, .usdcOnPolygon: nil,
        .usdtOnPolygon: nil,
    ]
    init() {
        self.wallet = WalletAccessor()
    }
}

extension Web3Model {
    func balanceFor(_ token: TokenType) -> String? {
        balances[token]!
    }

    func updateBalances() {
        CurrencyStore.shared.refresh()
        balances.keys.forEach { token in
            wallet?.tokenBalance(token: token) { balance in
                self.balances[token] = balance
                self.objectWillChange.send()
                print("更新")
            }
        }
    }
}

extension Web3Model {
    func store() {
        Defaults[.walletName].append(self.walletDetailsModel.walletName)
        Defaults[.walletPassword].append(self.walletDetailsModel.walletPassword)
    }
    func clear() {
        Defaults[.walletAddress].removeAll()
    }
}

extension Web3Model {
    func getNowAddress() -> String {
        if Defaults[.walletNowAddress] == "" {
            return ""
        }else {
            return Defaults[.walletNowAddress]
        }
    }
}
