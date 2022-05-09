//
//  MegaNFTSellView.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI

struct MegaNFTSellView: View {
    let tokenId: String
    @EnvironmentObject var store: Store
    var MegaNFTSellBinding: Binding<AppState.NFTSell>{
        $store.appState.NFTSell
    }
    var MegaNFTSell: AppState.NFTSell {
        store.appState.NFTSell
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Text("当前地址")
            Text(UserDefaults.standard.string(forKey: "walletAddress")!)
                .padding()
                .background(Color("MegaBackgroundColorGray"))
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
            Text("当前网络")
            Text("rinkeby")
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color("MegaBackgroundColorGray"))
                .cornerRadius(10)
            Text("输入价格")
            TextField("单行输入", text: MegaNFTSellBinding.NFTSellPrice)
                .padding()
                .foregroundColor(Color.gray.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color("MegaBackgroundColorGray"))
                .cornerRadius(10)
            if store.appState.NFTSell.url != "" {
                Text(store.appState.NFTSell.url)
//                Link("OpenSea资产页面", destination: URL(string: store.appState.NFTSell.url)!)
            }
            Spacer()
        }
        .alert(isPresented: MegaNFTSellBinding.createFail) {
            Alert(title: Text("出售失败"), message: Text("请检查服务或过一会再试"), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: MegaNFTSellBinding.createSuccess) {
            Alert(title: Text("出售成功"), message: Text(store.appState.NFTSell.url), dismissButton:
                    Alert.Button.default(
                        Text("OK"), action: {
                            self.store.dispatch(
                                .NFTAssetTypeChangeRequest(tokenId: tokenId, temp: "1")
                            )
                        }
                    )
            )
        }
        .onDisappear(perform: {
            store.appState.NFTSell.createFail = false
            store.appState.NFTSell.createSuccess = false
        })
        .padding()
    }
}

//struct MegaNFTSellView_Previews: PreviewProvider {
//    static var previews: some View {
//        let store = Store()
//        return MegaNFTSellView().environmentObject(store)
//    }
//}

