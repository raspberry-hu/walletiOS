//
//  MegaNFTOpenSeaAssetEventView.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI

struct MegaNFTOpenSeaAssetEventView: View {
@EnvironmentObject var store: Store
@State var NFTAsset: [NFTGetAssetImageResponse]?
let sellTemp: Int
var body: some View {
    VStack{
        List{
            if NFTAsset == nil {
                Text("加载失败,请重新刷新页面")
                    .font(.largeTitle)
            } else if NFTAsset?.count == 0{
                Text("请先创造您的第一个NFT！")
                    .font(.largeTitle)
            } else {
                let test = NFTAsset?.filter { $0.orderStatus == sellTemp }
                ForEach(0..<(test!.count-1)/2+1){ i in
                    MegaWalletNFTDetailImage(i: i, test: test!)
                    }
                }
            }
        }
    }
}
