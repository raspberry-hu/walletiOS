//
//  walletView.swift
//  MEGA
//
//  Created by hu on 2022/03/02.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI

struct BoatDetailsView: View {
//    @StateObject var vm = CoreDataManager.shared
    var shipName = ""
    var body: some View {
        TabView {
            NFTAssetView()
                .tabItem {
                    Image(systemName: "bitcoinsign.square")
                    Text("资产")
                }
            NFTMarketView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("NFT市场")
                }
            DSCDriveView()
                .tabItem {
                    Image(systemName: "externaldrive.badge.icloud")
                    Text("DSC网盘")
                }
            walletSetView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("设置")
                }
        }
        .font(.headline)
    }
}

