//
//  MegaWalletNFTImageShowView.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI
import Kingfisher

struct AssetImageSheet: View{
    @EnvironmentObject var store: Store
    @State var isLinkActive = false
    @State var isLinkActiveFirst = false
    let nftName: String
    let description: String
    let image: String
    let externalLink: String
    let inputArr: String
    let mintNum: String
    let walletAddress: String
    let tokenId: String
    var body: some View{
        var _: [String] = [nftName, description, image, externalLink, inputArr, mintNum, walletAddress]
        NavigationView {
        HStack{
            VStack(alignment: .leading, spacing: 10){
                HStack {
                    KFImage(URL(string: image))
                        .resizable()
                        .frame(width: 128, height: 128)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    Text(nftName)
                        .multilineTextAlignment(.center)
                        .font(.title)
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 3){
                    Text("详情描述")
                    Text(description)
                        .font(.footnote)
                }
                VStack(alignment: .leading, spacing: 3){
                    Text("详情链接")
                    Text(externalLink)
                        .font(.footnote)
                }
                VStack(alignment: .leading, spacing: 3){
                    Text("所属集合")
                    Text(inputArr)
                        .font(.footnote)
                }
                VStack(alignment: .leading, spacing: 3){
                    Text("铸造个数")
                    Text(mintNum)
                        .font(.footnote)
                }
                VStack(alignment: .leading, spacing: 3){
                    Text("钱包地址")
                    Text(walletAddress)
                        .font(.footnote)
                }
                HStack {
                    NavigationLink(
                        destination: MegaNFTSellView(tokenId: tokenId)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        let postContent = NFTSellRequest(network: "rinkeby", ownerAddress: UserDefaults.standard.string(forKey: "walletAddress")!, myMnemonic: UserDefaults.standard.string(forKey: "walletMnemonic")!, fixPrice: Double(store.appState.NFTSell.NFTSellPrice)!, tokenId: tokenId)
                                        self.store.dispatch(
                                            .NFTSellGet(postContent: postContent)
                                        )
                                    } label: {
                                        Text("完成")
                                            .foregroundColor(Color("MegaWalletCreateColorGreen"))
                                    }
                                }
                            }
                    ) {
                        Text("定价销售")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("MegaWalletCreateColorGreen"))
                            .cornerRadius(5)
                    }
                    Spacer()
                    NavigationLink(
                        destination: MegaNFTAuctionView(tokenId: tokenId)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        let postEnContent = NFTEndlandAuctionRequest(network: "rinkeby", ownerAddress: UserDefaults.standard.string(forKey: "walletAddress")!, myMnemonic: UserDefaults.standard.string(forKey: "walletMnemonic")!, startPrice: Double(store.appState.NFTAuction.startPrice)!, expirationTime: Int(store.appState.NFTAuction.time.timeIntervalSince1970), tokenId: tokenId)
                                        let postNeContent = NFTNetherlandsAuctionRequest(network: "rinkeby", ownerAddress: UserDefaults.standard.string(forKey: "walletAddress")!, myMnemonic: UserDefaults.standard.string(forKey: "walletMnemonic")!, startPrice: Double(store.appState.NFTAuction.startPrice)!, endPrice: Double(store.appState.NFTAuction.endPrice)!, expirationTime: Int(store.appState.NFTAuction.time.timeIntervalSince1970), tokenId: tokenId)
                                        if store.appState.NFTAuction.temp == "英国式拍卖" {
                                            self.store.dispatch(
                                                .NFTEnAuctionGet(postContent: postEnContent)
                                            )
                                        } else {
                                            self.store.dispatch(
                                                .NFTNeAuctionGet(postContent: postNeContent)
                                            )
                                        }
                                    } label: {
                                        Text("完成")
                                            .foregroundColor(Color("MegaWalletCreateColorGreen"))
                                    }
                                }
                            }
                    ) {
                        Text("定价拍卖")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("MegaWalletCreateColorGreen"))
                            .cornerRadius(5)
                    }

                    Spacer()
                    NavigationLink(
                        destination: MegaNFTBundleView(tokenId: tokenId)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        let postContent = NFTBundleSellRequest(network: "rinkeby", ownerAddress: UserDefaults.standard.string(forKey: "walletAddress")!, myMnemonic: UserDefaults.standard.string(forKey: "walletMnemonic")!, bundleName: store.appState.NFTBundle.bundleName, bundleDescription: store.appState.NFTBundle.bundleDescription, startPrice: Double(store.appState.NFTBundle.startPrice)!, expirationTime: Int(store.appState.NFTAuction.time.timeIntervalSince1970), tokenId: store.appState.NFTBundle.tokenID)
                                        self.store.dispatch(
                                            .NFTBundleGet(postContent: postContent)
                                        )
                                    } label: {
                                        Text("完成")
                                            .foregroundColor(Color("MegaWalletCreateColorGreen"))
                                    }
                                }
                            }
                    ) {
                        Text("捆绑销售")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("MegaWalletCreateColorGreen"))
                            .cornerRadius(5)
                        }
                    }
                Spacer()
                }
            .padding()
            }
        .onDisappear(perform: {
            store.appState.NFTBundle.url = ""
            store.appState.NFTBundle.tokenID = [Int]()
            store.appState.NFTBundle.startPrice = "0.0"
            store.appState.NFTAuction.url = ""
            store.appState.NFTAuction.startPrice = "0.0"
            store.appState.NFTAuction.endPrice = "0.0"
            store.appState.NFTAuction.url = ""
            store.appState.NFTSell.url = ""
            store.appState.NFTSell.NFTSellPrice = ""
        })
        .ignoresSafeArea()
        }
    }
}

