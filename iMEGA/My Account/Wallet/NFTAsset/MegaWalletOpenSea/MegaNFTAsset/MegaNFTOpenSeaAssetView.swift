//
//  MegaNFTOpenSeaAssetView.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation
import SwiftUI

struct MegaNFTOpenSeaAssetView: View {
    @EnvironmentObject var store: Store
    @State var NFTAsset: [NFTGetAssetImageResponse]?
    let sellTemp: Int
    var body: some View {
        VStack{
            List{
                if NFTAsset == nil || NFTAsset?.count == 0{
                    Text("加载失败,请重新刷新页面")
                } else {
                    let test = NFTAsset?.filter { $0.orderStatus == sellTemp }
                    ForEach(0..<(test!.count-1)/2+1){ i in
                        MegaWalletNFTImageList(i: i, test: test!)
                    }
                }
            }
//            .refreshable {
//                self.store.dispatch(
//                    .NFTAssetDetailGet(address: "0x6a22409c4e1df5fce2ec74a5b70d222723e83066", number: String(sellTemp))
//                )
//                self.NFTAsset = store.appState.NFTAssetDetail.NFTAssetImage
//            }
        }
    }
}
