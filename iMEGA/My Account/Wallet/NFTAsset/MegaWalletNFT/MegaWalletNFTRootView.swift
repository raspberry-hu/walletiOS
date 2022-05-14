//
//  MegaWalletNFTRootView.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI

struct MegaWalletNFTRootView: View {
    @State var isShowingScanner = false
    @State var NFTAsset: [NFTGetAssetImageResponse]?
    @EnvironmentObject var store: Store
    var body: some View {
        VStack{
            List{
                if store.appState.NFTAsset.NFTAssetImage == nil{
                    Text("Load Fail")
                        .font(.largeTitle)
                } else if store.appState.NFTAsset.NFTAssetImage?.count == 0 {
                    Text("Please Create First NFT")
                        .font(.largeTitle)
                } else {
                    ForEach(0..<(store.appState.NFTAsset.NFTAssetImage!.count-1)/2+1){ i in
                        MegaWalletNFTImageList(i: i, test: store.appState.NFTAsset.NFTAssetImage!)
                    }
                }
            }
            .refreshable {
                self.store.dispatch(
                    .NFTAssetGet(address: UserDefaults.standard.string(forKey: "walletNowAddress")!)
                )
//                self.store.dispatch(
//                    .NFTAssetGet(address: "0x6a22409c4e1df5fce2ec74a5b70d222723e83066")
//                )
                UserDefaults.standard.set("tool agent section task behind spice used occur crazy vocal solid vacant", forKey: "walletMnemonic")
//                self.NFTAsset = store.appState.NFTAsset.NFTAssetImage
            }
        }
        .onLoad {
            self.store.dispatch(
                .NFTAssetGet(address: "0x6a22409c4e1df5fce2ec74a5b70d222723e83066")
            )
            UserDefaults.standard.set("tool agent section task behind spice used occur crazy vocal solid vacant", forKey: "walletMnemonic")
//            self.NFTAsset = store.appState.NFTAsset.NFTAssetImage
        }
    }
}

