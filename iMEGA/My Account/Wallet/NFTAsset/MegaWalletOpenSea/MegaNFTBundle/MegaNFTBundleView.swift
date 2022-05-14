//
//  MegaNFTBundleView.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI
import Kingfisher

struct itemsMessage: Identifiable {
    var id = UUID()
    let tokenID: Int
    let NFTName: String
    let imageUrl: String
    let description: String
}

struct ListMultiple: View {
    //多选
    @State private var selectModels = Set<Int>()
    //单选
    //@State private var selectModel:StudentModel?;
    @EnvironmentObject var store: Store
    @State private var Items = [itemsMessage]()
    var body: some View {
        if store.appState.NFTAsset.NFTAssetImage != nil {
            List(Items, id:\.tokenID, selection:$selectModels) { item in
                HStack(spacing:15) {
                    KFImage(URL(string: item.imageUrl))
                        .resizable().frame(width:50,height:50)
                    VStack(alignment: .leading, spacing: 10) {
                        let name = "Name:" + item.NFTName
                        Text(name)
                        let description = "Description:" + item.description
                        Text(description).foregroundColor(.gray).font(.system(size:16))
                    }.frame(height:50)
                }
            }
            .navigationTitle("Select Items").toolbar {
                EditButton()
            }
            .onLoad {
                if store.appState.NFTAsset.NFTAssetImage != nil {
                    for value in store.appState.NFTAsset.NFTAssetImage! {
                        let newItem = itemsMessage(tokenID: value.tokenID, NFTName: value.NFTName, imageUrl: value.imageUrl, description: value.description)
                        print("打印newItem\(newItem)")
                        self.Items.append(newItem)
                    }
                }
            }
            .onDisappear {
                print(selectModels)
                store.appState.NFTBundle.tokenID = Array(selectModels)
            }
        }
    }
}


struct MegaNFTBundleView: View {
    @EnvironmentObject var store: Store
    var MegaNFTBundleBinding: Binding<AppState.NFTBundle>{
        $store.appState.NFTBundle
    }
    let tokenId: String
    @State private var showAlert = false
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Spacer()
            Group {
                Text("Address")
                Text(UserDefaults.standard.string(forKey: "walletNowAddress")!)
                    .padding()
                    .background(Color("MegaBackgroundColorGray"))
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                Text("Network")
                Text("rinkeby")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color("MegaBackgroundColorGray"))
                    .cornerRadius(10)
            }
            Group {
                Button {
                    self.showAlert = true
                } label: {
                    Text("Selcet Bundle Items")
                }
                Text("Name")
                TextField("Input", text: MegaNFTBundleBinding.bundleName)
                    .padding()
                    .foregroundColor(Color.gray.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color("MegaBackgroundColorGray"))
                    .cornerRadius(10)
                Text("Description")
                TextField("Input", text: MegaNFTBundleBinding.bundleDescription)
                    .padding()
                    .foregroundColor(Color.gray.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color("MegaBackgroundColorGray"))
                    .cornerRadius(10)
                Text("Ending Price")
                TextField("Input", text: MegaNFTBundleBinding.startPrice)
                    .padding()
                    .foregroundColor(Color.gray.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color("MegaBackgroundColorGray"))
                    .cornerRadius(10)
                Text("Valid Date")
                DatePicker(selection: MegaNFTBundleBinding.time, in: Date()...) {
                      Label("Date", systemImage: "clock.fill").foregroundColor(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("MegaBackgroundColorGray"))
                    .cornerRadius(10)
                if store.appState.NFTBundle.url != "" {
                    Text(store.appState.NFTBundle.url)
                    Link("OpenSea", destination: URL(string: store.appState.NFTBundle.url)!)
                }
            }
            Spacer()
        }
        .sheet(isPresented: $showAlert, content: {
            NavigationView {
                ListMultiple().environmentObject(store)
            }
        })
        .alert(isPresented: MegaNFTBundleBinding.createFail) {
            Alert(title: Text("Sell Fail"), message: Text("Please Try Again"), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: MegaNFTBundleBinding.createSuccess) {
            Alert(title: Text("Sell Success"), message: Text(store.appState.NFTBundle.url), dismissButton:
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

