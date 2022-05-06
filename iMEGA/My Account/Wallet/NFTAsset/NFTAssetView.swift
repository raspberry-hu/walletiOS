//
//  NFTAssetView.swift
//  MEGA
//
//  Created by hu on 2022/03/22.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI
import Defaults

struct NFTAssetView: View {
    @EnvironmentObject var web3Model: Web3Model
    private var walletOptions = ["虚拟货币", "NFT", "挂单信息"]
    @State private var selctedItem: Int = 0
    @State private var searchText: String = ""
    var body: some View {
        VStack {
            VStack {
                MegaWalletRootViewSearch(searchText: $searchText)
                    .frame(width:UIScreen.screenWidth * 0.95 , height: UIScreen.screenWidth / 12)
                    .padding(.top, 8)
                HStack {
                    Text("Address: ")
                    Text(web3Model.publicAddress.prefix(6))
                    Spacer()
                    Text("Balance: $\(web3Model.balanceFor(TokenType.ether) ?? "0")")
                        .padding()
                }
                .frame(width:UIScreen.screenWidth * 0.93)
                Section(){
                    Picker("Gender", selection: $selctedItem) {
                        ForEach(0..<walletOptions.count) {
                            Text(self.walletOptions[$0])
                        }
                    }.pickerStyle( SegmentedPickerStyle())
                }
                .padding()
                if selctedItem == 0 {
                    Text("1")
                }
                if selctedItem == 1 {
                    Text("2")
                }
                if selctedItem == 2 {
                    Text("3")
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}

struct MegaWalletRootViewSearch: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack{
            HStack{
                Image(systemName: "magnifyingglass")
                    .padding(.leading, 10)
                TextField("Search", text: $searchText)
            }
            .frame(height: 30)
            .background(Color("E6E6E6"))
            .cornerRadius(40)
            Text("取消")
        }
    }
}
