//
//  NFTAssetView.swift
//  MEGA
//
//  Created by hu on 2022/03/22.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI

struct NFTAssetView: View {
    @EnvironmentObject var web3Model: Web3Model
    private var walletOptions = ["虚拟货币", "NFT", "挂单信息"]
    @State private var selctedItem: Int = 0
    var body: some View {
        VStack {
            VStack {
                Text("Eth Balance")
                    .font(.title)
                    .padding()
                Text("$5038.76")
                    .font(.title)
                Section(){
                    Picker("Gender", selection: $selctedItem) {
                        ForEach(0..<walletOptions.count) {
                            Text(self.walletOptions[$0])
                        }
                    }.pickerStyle( SegmentedPickerStyle())
                }
                .padding()
                if selctedItem == 0 {
//                    MegaWalletCoinView()
                    Text("1")
                }
                if selctedItem == 1 {
//                    MegaWalletNFTRootView(NFTAsset: store.appState.NFTAsset.NFTAssetImage)
                    Text("2")
                }
                if selctedItem == 2 {
//                    MegaWalletOpenSeaRootView()
//                        .padding(.top, 78)
                    Text("3")
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}
