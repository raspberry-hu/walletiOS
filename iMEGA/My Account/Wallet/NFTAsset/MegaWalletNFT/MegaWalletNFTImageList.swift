//
//  MegaWalletNFTImageList.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI
import Kingfisher
import SheetKit

struct MegaWalletNFTImageList: View {
    var i:Int
    var test:[NFTGetAssetImageResponse]
    @EnvironmentObject var store: Store
    @State private var presentingSheet = false
    var body: some View{
        let temp = test.count-1-i
        HStack{
            VStack{
                KFImage(URL(string: test[i].imageUrl))
                    .cancelOnDisappear(true)
                    .resizable()
                    .frame(width: UIScreen.screenWidth * 0.3, height: UIScreen.screenWidth * 0.3)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .onTapGesture {
                        SheetKit().present(with: .bottomSheet) {
                            AssetImageSheet(nftName: test[i].NFTName, description: test[i].description, image: test[i].imageUrl, externalLink: test[i].descriptionLink, inputArr: test[i].set, mintNum: test[i].number, walletAddress: test[i].walletAddress, tokenId: String(test[i].tokenID)).environmentObject(self.store)
                        }
                    }
                Text(test[i].NFTName)
                    .lineLimit(1)
                    .shadow(radius: 10)
            }
            .frame(width: UIScreen.screenWidth * 0.3, height: UIScreen.screenWidth * 0.5)
            Spacer()
            if temp != i{
                VStack{
                    KFImage(URL(string: test[temp].imageUrl))
                        .cancelOnDisappear(true)
                        .resizable()
                        .frame(width: UIScreen.screenWidth * 0.3, height: UIScreen.screenWidth * 0.3)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .onTapGesture {
                            SheetKit().present(with: .bottomSheet) {
                                AssetImageSheet(nftName: test[temp].NFTName, description: test[temp].description, image: test[temp].imageUrl, externalLink: test[temp].descriptionLink, inputArr: test[temp].set, mintNum: test[temp].number, walletAddress: test[temp].walletAddress, tokenId: String(test[temp].tokenID)).environmentObject(self.store)
                            }
                        }
                    Text(test[temp].NFTName)
                        .lineLimit(1)
                        .shadow(radius: 10)
                }
                .frame(width: UIScreen.screenWidth * 0.3, height: UIScreen.screenWidth * 0.5)
            }
        }
    }
}

