//
//  MegaNFTBundleView.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI

struct MegaNFTBundleView: View {
    @EnvironmentObject var store: Store
    var MegaNFTBundleBinding: Binding<AppState.NFTBundle>{
        $store.appState.NFTBundle
    }
    let tokenId: String
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Spacer()
            Group {
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
            }
            Group {
                Text("组合名称")
                TextField("单行输入", text: MegaNFTBundleBinding.bundleName)
                    .padding()
                    .foregroundColor(Color.gray.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color("MegaBackgroundColorGray"))
                    .cornerRadius(10)
                Text("组合描述")
                TextField("单行输入", text: MegaNFTBundleBinding.bundleDescription)
                    .padding()
                    .foregroundColor(Color.gray.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color("MegaBackgroundColorGray"))
                    .cornerRadius(10)
                Text("起始价格")
                TextField("单行输入", text: MegaNFTBundleBinding.startPrice)
                    .padding()
                    .foregroundColor(Color.gray.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color("MegaBackgroundColorGray"))
                    .cornerRadius(10)
                Text("有效期")
                DatePicker(selection: MegaNFTBundleBinding.time, in: Date()...) {
                      Label("日期", systemImage: "clock.fill").foregroundColor(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("MegaBackgroundColorGray"))
                    .cornerRadius(10)
                if store.appState.NFTBundle.url != "" {
                    Text(store.appState.NFTBundle.url)
                    Link("OpenSea资产页面", destination: URL(string: store.appState.NFTBundle.url)!)
                }
            }
            Spacer()
        }
        .alert(isPresented: MegaNFTBundleBinding.createFail) {
            Alert(title: Text("出售失败"), message: Text("请检查服务或过一会再试"), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: MegaNFTBundleBinding.createSuccess) {
            Alert(title: Text("出售成功"), message: Text(store.appState.NFTBundle.url), dismissButton:
                    Alert.Button.default(
                        Text("OK"), action: {
                            self.store.dispatch(
                                .NFTAssetTypeChangeRequest(tokenId: tokenId, temp: "3")
                            )
                        }
                    )
            )
        }
        .onDisappear(perform: {
            store.appState.NFTBundle.createSuccess = false
            store.appState.NFTBundle.createFail = false
        })
        .padding()
    }
}

//struct MegaNFTBundleView_Previews: PreviewProvider {
//    static var previews: some View {
//        MegaNFTBundleView()
//    }
//}

