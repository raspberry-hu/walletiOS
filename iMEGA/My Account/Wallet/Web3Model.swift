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

class WalletDetailsModel: ObservableObject {
    @Published var walletName: String = ""
    @Published var walletPassword: String = ""
    @Published var walletSetDone = false
}

class Web3Model: ObservableObject {
    @Published var walletDetailsModel: WalletDetailsModel = WalletDetailsModel()
}

extension Web3Model {
    func store() {
        Defaults[.walletName].append(self.walletDetailsModel.walletName)
        Defaults[.walletPassword].append(self.walletDetailsModel.walletPassword)
    }
}
