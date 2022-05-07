//
//  MegaWalletNFTDetailSheet.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI
import Kingfisher

struct MegaWalletNFTDetailSheet: View {
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
            VStack(alignment: .center, spacing: 10) {
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
                }
                if store.appState.NFTEvent.NFTEventDetail != nil {
                    NavigationLink(
                        destination: MegaWalletNFTEventDetailSubView()
                    ) {
                        Text("查看事件信息")
                            .frame(width: UIScreen.screenWidth * 0.8, height: UIScreen.screenWidth * 0.1,alignment: .center)
                            .font(.title3)
                            .foregroundColor(.white)
                            .background(Color("MegaWalletCreateColorGreen"))
                            .cornerRadius(5)
                    }

                } else {
                    Text("查看事件信息")
//                        .font(.title3)
//                        .foregroundColor(.white)
//                        .background(Color("MegaWalletCreateColorGreen"))
//                        .cornerRadius(5)
//                        .redacted(reason: .placeholder)
//                        .padding(.leading, UIScreen.screenWidth * 0.3)
                        .frame(width: UIScreen.screenWidth * 0.8, height: UIScreen.screenWidth * 0.1,alignment: .center)
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(Color("MegaWalletCreateColorGreen"))
                        .cornerRadius(5)
                        .redacted(reason: .placeholder)
                }
            }
            .padding()
            }
            .ignoresSafeArea()
        }
        .onAppear {
            self.store.dispatch(
                .NFTEventGet(postContent: NFTGetEventsRequest(assetContractAddress: "0x258072A823f55e9a7Ea242E6Bc6762444df15192", accountAddress: "", tokenId: Int(self.tokenId)!, limit: "", onlyOpensea: "", eventType: "", auctionType: ""))
            )
        }
        .onDisappear {
                    store.appState.NFTEvent.NFTEventDetail = nil
        }
    }
}

//struct MegaWalletNFTDetailSheetSubView: View {
//    @EnvironmentObject var store: Store
//    let temp: Int
//    var body: some View {
//        HStack {
//            Text((store.appState.NFTEvent.NFTEventDetail?.msg[temp].eventType)!)
//            if store.appState.NFTEvent.NFTEventDetail?.msg[temp].totalPrice == nil && store.appState.NFTEvent.NFTEventDetail?.msg[temp].endingPrice != nil && store.appState.NFTEvent.NFTEventDetail?.msg[temp].startingPrice != nil {
//                Text((store.appState.NFTEvent.NFTEventDetail?.msg[temp].endingPrice![..<4])!)
//                Text((store.appState.NFTEvent.NFTEventDetail?.msg[temp].startingPrice![..<4])!)
//            } else if store.appState.NFTEvent.NFTEventDetail?.msg[temp].totalPrice != nil {
//                Text((store.appState.NFTEvent.NFTEventDetail?.msg[temp].totalPrice![..<4])!)
//            } else {
//                Text("Null")
//            }
//            if store.appState.NFTEvent.NFTEventDetail?.msg[temp].fromAccount != nil {
//                Text((store.appState.NFTEvent.NFTEventDetail?.msg[temp].fromAccount?.address[2..<6])!)
//            } else {
//                Text("Null")
//            }
//            if store.appState.NFTEvent.NFTEventDetail?.msg[temp].toAccount != nil {
//                Text((store.appState.NFTEvent.NFTEventDetail?.msg[temp].toAccount?.address[2..<6])!)
//            } else {
//                Text("Null")
//            }
//            Text((store.appState.NFTEvent.NFTEventDetail?.msg[temp].createdDate[5..<10])!)
//        }
//    }
//}

