//
//  MegaWalletOpenSeaRootView.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI
import Defaults

struct MegaWalletOpenSeaRootView: View {
    @EnvironmentObject var store: Store
    @State var NFTTemp = true
    @State var NFTAssetDeatilSell: [NFTGetAssetImageResponse]?
//    @State var NFTAssetDeatilAuction: [NFTGetAssetImageResponse]?
//    @State var NFTAssetDeatilBundle: [NFTGetAssetImageResponse]?
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if store.appState.NFTAssetDetail.NFTAssetImage != nil {
                NavigationLink(destination: MegaNFTOpenSeaAssetEventView(NFTAsset: store.appState.NFTAssetDetail.NFTAssetImage, sellTemp: 1).environmentObject(store).navigationBarTitleDisplayMode(.inline)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(1))
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth - 15, minHeight: 0, maxHeight: 60)
                            .shadow(radius: 5)
                        HStack {
                            Image(systemName: "filemenu.and.selection")
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                            Text("Fix Sell")
                                .foregroundColor(.black)
                                .padding()
                            Spacer()
                            Image(systemName: "arrow.forward.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .frame(minWidth: 0, maxWidth: UIScreen.screenWidth - 40, minHeight: 0, maxHeight: 60)
                    }
                }
                NavigationLink(destination: MegaNFTOpenSeaAssetEventView(NFTAsset: store.appState.NFTAssetDetail.NFTAssetImage, sellTemp: 2).environmentObject(store).navigationBarTitleDisplayMode(.inline)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(1))
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth - 15, minHeight: 0, maxHeight: 60)
                            .shadow(radius: 5)
                        HStack {
                            Image(systemName: "person.3")
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                            Text("Auction Sell")
                                .foregroundColor(.black)
                                .padding()
                            Spacer()
                            Image(systemName: "arrow.forward.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .frame(minWidth: 0, maxWidth: UIScreen.screenWidth - 40, minHeight: 0, maxHeight: 60)
                    }
                }
                NavigationLink(destination: MegaNFTOpenSeaAssetEventView(NFTAsset: store.appState.NFTAssetDetail.NFTAssetImage, sellTemp: 3).environmentObject(store).navigationBarTitleDisplayMode(.inline)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(1))
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth - 15, minHeight: 0, maxHeight: 60)
                            .shadow(radius: 5)
                        HStack {
                            Image(systemName: "scribble")
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                            Text("Bundle Sell")
                                .foregroundColor(.black)
                                .padding()
                            Spacer()
                            Image(systemName: "arrow.forward.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .frame(minWidth: 0, maxWidth: UIScreen.screenWidth - 40, minHeight: 0, maxHeight: 60)
                    }
                }
            } else {
//                NavigationLink(destination: MegaNFTOpenSeaAssetView(NFTAsset: NFTAssetDeatilSell, sellTemp: 1)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(1))
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth - 15, minHeight: 0, maxHeight: 60)
                            .shadow(radius: 5)
                        HStack {
                            Image(systemName: "filemenu.and.selection")
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                            Text("Fix Sell")
                                .foregroundColor(.black)
                                .padding()
                            Spacer()
                            Image(systemName: "arrow.forward.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .frame(minWidth: 0, maxWidth: UIScreen.screenWidth - 40, minHeight: 0, maxHeight: 60)
                    }
//                }
//                NavigationLink(destination: MegaNFTOpenSeaAssetView(NFTAsset: NFTAssetDeatilSell, sellTemp: 2)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(1))
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth - 15, minHeight: 0, maxHeight: 60)
                            .shadow(radius: 5)
                        HStack {
                            Image(systemName: "person.3")
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                            Text("Auction Sell")
                                .foregroundColor(.black)
                                .padding()
                            Spacer()
                            Image(systemName: "arrow.forward.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .frame(minWidth: 0, maxWidth: UIScreen.screenWidth - 40, minHeight: 0, maxHeight: 60)
                    }
//                }
                NavigationLink(destination: MegaNFTOpenSeaAssetView(NFTAsset: NFTAssetDeatilSell, sellTemp: 3)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(1))
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth - 15, minHeight: 0, maxHeight: 60)
                            .shadow(radius: 5)
                        HStack {
                            Image(systemName: "scribble")
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                            Text("Bundle Sell")
                                .foregroundColor(.black)
                                .padding()
                            Spacer()
                            Image(systemName: "arrow.forward.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .frame(minWidth: 0, maxWidth: UIScreen.screenWidth - 40, minHeight: 0, maxHeight: 60)
                    }
                }
            }
        }
        .onAppear {
//            self.store.dispatch(
//                .NFTAssetDetailGet(address: "0x6a22409c4e1df5fce2ec74a5b70d222723e83066", number: String(1))
//            )
//            self.store.NFTAssetDeatilSell = store.appState.NFTAssetDetail.NFTAssetImage
//            self.store.dispatch(
//                .NFTAssetDetailGet(address: "0x6a22409c4e1df5fce2ec74a5b70d222723e83066", number: String(2))
//            )
//            self.store.NFTAssetDeatilAuction = store.appState.NFTAssetDetail.NFTAssetImage
//            self.store.dispatch(
//                .NFTAssetDetailGet(address: "0x6a22409c4e1df5fce2ec74a5b70d222723e83066", number: String(3))
//            )
//            self.store.NFTAssetDeatilBundle = store.appState.NFTAssetDetail.NFTAssetImage
//            self.store.dispatch(
//                .NFTAssetGet(address: UserDefaults.standard.string(forKey: "walletNowAddress")!)
//            )
            self.store.dispatch(
//                .NFTAssetGet(address: Defaults[.walletNowAddress])
                .NFTAssetDetailGet(address: Defaults[.walletNowAddress], number: String(4))
            )
            self.NFTAssetDeatilSell = store.appState.NFTAssetDetail.NFTAssetImage
            print("Detailappear更新成功")
            print(Defaults[.walletNowAddress])
            print(self.NFTAssetDeatilSell)
            print(store.appState.NFTAssetDetail.NFTAssetImage)
        }
    }
}
