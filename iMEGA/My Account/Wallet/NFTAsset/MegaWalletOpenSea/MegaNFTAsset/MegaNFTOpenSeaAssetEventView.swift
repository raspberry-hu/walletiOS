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
                Text("Load Fail")
                    .font(.largeTitle)
            } else if NFTAsset?.count == 0 || NFTAsset?.filter { $0.orderStatus == sellTemp }.count == 0{
                Text("Please Create First NFT")
                    .font(.largeTitle)
            } else {
                let test = NFTAsset?.filter { $0.orderStatus == sellTemp }
//                ForEach(0..<(test!.count-1)/2+1){ i in
//                    MegaWalletNFTDetailImage(i: i, test: test!)
//                    }
//                Text("个数\(test!.count)")
                ForEach(0..<(test!.count-1)/2 + 1){ i in
                    MegaWalletNFTDetailImage(i: i, test: test!).environmentObject(store)
                    }
                }
            }
        }
    }
}
