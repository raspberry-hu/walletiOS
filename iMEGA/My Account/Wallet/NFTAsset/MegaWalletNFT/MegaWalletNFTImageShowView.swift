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
//        NavigationView {
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
                    Text("Description")
                    Text(description)
                        .font(.footnote)
                }
                VStack(alignment: .leading, spacing: 3){
                    Text("ExternalLink")
                    Text(externalLink)
                        .font(.footnote)
                }
                VStack(alignment: .leading, spacing: 3){
                    Text("Collection")
                    Text(inputArr)
                        .font(.footnote)
                }
                VStack(alignment: .leading, spacing: 3){
                    Text("MintCount")
                    Text(mintNum)
                        .font(.footnote)
                }
                VStack(alignment: .leading, spacing: 3){
                    Text("Address")
                    Text(walletAddress)
                        .font(.footnote)
                }
                HStack {
                    NavigationLink(
                        destination: MegaNFTSellView(tokenId: tokenId).environmentObject(store)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        let postContent = NFTSellRequest(network: "rinkeby", ownerAddress: UserDefaults.standard.string(forKey: "walletNowAddress")!, myMnemonic: UserDefaults.standard.string(forKey: "walletMnemonic")!, fixPrice: Double(store.appState.NFTSell.NFTSellPrice)!, tokenId: tokenId)
                                        self.store.dispatch(
                                            .NFTSellGet(postContent: postContent)
                                        )
                                    } label: {
                                        Text("Finish")
                                            .foregroundColor(Color("00C29A"))
                                    }
                                }
                            }
                    ) {
                        Text("Fix Sell")
                            .font(.title3)
//                            .frame(width: UIScreen.screenWidth * 0.2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("00C29A"))
                            .cornerRadius(5)
                    }
                    Spacer()
                    NavigationLink(
                        destination: MegaNFTAuctionView(tokenId: tokenId).environmentObject(store)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        let postEnContent = NFTEndlandAuctionRequest(network: "rinkeby", ownerAddress: UserDefaults.standard.string(forKey: "walletNowAddress")!, myMnemonic: UserDefaults.standard.string(forKey: "walletMnemonic")!, startPrice: Double(store.appState.NFTAuction.startPrice)!, expirationTime: Int(store.appState.NFTAuction.time.timeIntervalSince1970), tokenId: tokenId)
                                        let postNeContent = NFTNetherlandsAuctionRequest(network: "rinkeby", ownerAddress: UserDefaults.standard.string(forKey: "walletNowAddress")!, myMnemonic: UserDefaults.standard.string(forKey: "walletMnemonic")!, startPrice: Double(store.appState.NFTAuction.startPrice)!, endPrice: Double(store.appState.NFTAuction.endPrice)!, expirationTime: Int(store.appState.NFTAuction.time.timeIntervalSince1970), tokenId: tokenId)
                                        if store.appState.NFTAuction.temp == "British Card" {
                                            self.store.dispatch(
                                                .NFTEnAuctionGet(postContent: postEnContent)
                                            )
                                        } else {
                                            self.store.dispatch(
                                                .NFTNeAuctionGet(postContent: postNeContent)
                                            )
                                        }
                                    } label: {
                                        Text("Finish")
                                            .foregroundColor(Color("00C29A"))
                                    }
                                }
                            }
                    ) {
                        Text("Auction Sell")
                            .font(.title3)
//                            .frame(width: UIScreen.screenWidth * 0.2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("00C29A"))
                            .cornerRadius(5)
                    }

                    Spacer()
                    NavigationLink(
                        destination: MegaNFTBundleView(tokenId: tokenId).environmentObject(store)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        let postContent = NFTBundleSellRequest(network: "rinkeby", ownerAddress: UserDefaults.standard.string(forKey: "walletNowAddress")!, myMnemonic: UserDefaults.standard.string(forKey: "walletMnemonic")!, bundleName: store.appState.NFTBundle.bundleName, bundleDescription: store.appState.NFTBundle.bundleDescription, startPrice: Double(store.appState.NFTBundle.startPrice)!, expirationTime: Int(store.appState.NFTAuction.time.timeIntervalSince1970), tokenId: store.appState.NFTBundle.tokenID)
                                        self.store.dispatch(
                                            .NFTBundleGet(postContent: postContent)
                                        )
                                    } label: {
                                        Text("Finish")
                                            .foregroundColor(Color("00C29A"))
                                    }
                                }
                            }
                    ) {
                        Text("Bundle Sell")
                            .font(.title3)
//                            .frame(width: UIScreen.screenWidth * 0.25)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("00C29A"))
                            .cornerRadius(5)
                        }
                    }
//                Spacer()
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
//        .ignoresSafeArea()
    }
}

