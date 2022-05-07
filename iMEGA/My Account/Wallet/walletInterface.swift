//
//  walletInterface.swift
//  MEGA
//
//  Created by hu on 2022/03/02.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation
import SwiftUI
import web3swift
@objc
class WalletRootInterface: NSObject {
    let web3Model = Web3Model()
    @objc func makeWalletRootViewUI() -> UIViewController{
        let view = WalletRootView().environmentObject(web3Model).environmentObject(Store())
        return UIHostingController(rootView: view)
    }
}
