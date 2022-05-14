//
//  MegaNFTAuctionView.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

//
//  MegaNFTAuctionView.swift
//  MegaWalletV3
//
//  Created by hu on 2021/11/23.
//

import SwiftUI

struct MegaNFTAuctionView: View {
    @EnvironmentObject var store: Store
    var MegaNFTAuctionBinding: Binding<AppState.NFTAuction>{
        $store.appState.NFTAuction
    }
    private let auction = [
      "British Card","Dutch Auction"
    ]
    let tokenId: String
//    @State private var selectedAuction = "英国式拍卖"
//    @State private var selectedDate = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: 5){
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
                Text("Select Auction")
                Picker(selection: MegaNFTAuctionBinding.temp, label: Text("wallet")) {
                    ForEach(auction, id: \.self) { (string: String) in
                        Text(string)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            Group {
//                TextField("单行输入", text: MegaNFTSellBinding.NFTSellPrice)
//                    .padding()
//                    .foregroundColor(Color.gray.opacity(0.8))
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .background(Color("MegaBackgroundColorGray"))
//                    .cornerRadius(10)
                Text("Starting Price")
                TextField("Input", text: MegaNFTAuctionBinding.startPrice)
                    .padding()
                    .foregroundColor(Color.gray.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color("MegaBackgroundColorGray"))
                    .cornerRadius(10)
                if store.appState.NFTAuction.temp != "British Card" {
                    Text("Ending Price")
                    TextField("Input", text: MegaNFTAuctionBinding.endPrice)
                        .padding()
                        .foregroundColor(Color.gray.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color("MegaBackgroundColorGray"))
                        .cornerRadius(10)
                }
                Text("Validity period")
//                HStack {
//                    Image(systemName: "calendar.day.timeline.right")
                DatePicker(selection: MegaNFTAuctionBinding.time, in: Date()...) {
                      Label("Date", systemImage: "clock.fill").foregroundColor(.blue)
//                      Text(selectedDate.formatted(date: .long, time: .omitted))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("MegaBackgroundColorGray"))
                    .cornerRadius(10)
                if store.appState.NFTAuction.url != "" {
                    Text(store.appState.NFTAuction.url)
                    Link("OpenSea", destination: URL(string: store.appState.NFTAuction.url)!)
                }
//                }
//                Image(systemName: "calendar.day.timeline.right")
//                    .padding()
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .background(Color("MegaBackgroundColorGray"))
//                    .cornerRadius(10)
            }
            .alert(isPresented: MegaNFTAuctionBinding.createFail) {
                Alert(title: Text("Sell Fail"), message: Text("Please Try Again"), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: MegaNFTAuctionBinding.createSuccess) {
                Alert(title: Text("Sell Success"), message: Text(store.appState.NFTAuction.url), dismissButton:
                        Alert.Button.default(
                            Text("OK"), action: {
                                self.store.dispatch(
                                    .NFTAssetTypeChangeRequest(tokenId: tokenId, temp: "2")
                                )
                            }
                        )
                )
            }
            .onDisappear {
                store.appState.NFTAuction.createSuccess = false
                store.appState.NFTAuction.createFail = false
            }
            Spacer()
        }
        .padding()
    }
}

//struct MegaNFTAuctionView_Previews: PreviewProvider {
//    static var previews: some View {
//        MegaNFTAuctionView()
//    }
//}

