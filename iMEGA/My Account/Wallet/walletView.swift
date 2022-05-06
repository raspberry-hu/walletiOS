//
//  walletView.swift
//  MEGA
//
//  Created by hu on 2022/03/02.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI

struct WalletRootView: View {
    @EnvironmentObject var web3Model: Web3Model
    var body: some View {
        TabView {
            NFTAssetView().environmentObject(web3Model)
                .tabItem {
                    Image(systemName: "bitcoinsign.square")
                    Text("NFT Asset")
                }
            NFTMarketView().environmentObject(web3Model)
                .tabItem {
                    Image(systemName: "cart")
                    Text("NFT Wallet")
                }
            DSCDriveView().environmentObject(web3Model)
                .tabItem {
                    Image(systemName: "externaldrive.badge.icloud")
                    Text("DSC Drive")
                }
            walletSetView().environmentObject(web3Model)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Wallet Set")
                }
        }
        .font(.headline)
    }
}

