//
//  MegaWalletCoinView.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI
import SheetKit

@available(iOS 14.0, *)
struct MegaWalletCoinView: View {
    @EnvironmentObject var store: Store
    @State private var showCoinAddSheet = false
    @State var contentArray = PlistOperator.init().getCoinItem()!
    @State var coinAdd = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Ethereum")
                    .padding()
                    .font(.system(size: 30, weight: .semibold, design: .default))
                Image(systemName: "plus.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .onTapGesture {
                        SheetKit().present(with: .bottomSheet) {
                            showCoinAddSheetView(coinAdd: $coinAdd, contentArray: $contentArray)
                        }
                    }
            }
            List(contentArray.indices) { item in
                MegaWalletCoinInfoView(number: item)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .refreshable {
                self.store.dispatch(
                    .coinDetailUpdate(name: contentArray)
                )
                self.store.dispatch(
                    .coinPriceUpdate(name: contentArray)
                )
            }
        }
    }
}

struct showCoinAddSheetView: View {
    @Binding var coinAdd: String
    @EnvironmentObject var store: Store
    @Binding var contentArray: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextField("添加币种", text: $coinAdd)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button {
                    PlistOperator.init().addCoinItem(name: coinAdd)
                    contentArray.append(coinAdd)
                    self.store.dispatch(
                        .coinDetailUpdate(name: contentArray)
                    )
                    self.store.dispatch(
                        .coinPriceUpdate(name: contentArray)
                    )
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.multicolor)
                }
            }
            ForEach(contentArray.indices, id: \.self) { item in
                HStack {
                    Text(contentArray[item])
                    Spacer()
                    Button {
                        PlistOperator.init().deleteCoinItem(name: contentArray[item])
                        self.contentArray.remove(at: item)
                    } label: {
                        Image(systemName: "minus.circle")
                            .symbolRenderingMode(.multicolor)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct MegaWalletCoinInfoView: View {
    let number: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(1))
                .frame(minWidth: 0, maxWidth: UIScreen.screenWidth - 10, minHeight: 0, maxHeight: 60)
                .shadow(radius: 3)
            MegaWalletCoinItemView(number: number)
                .frame(minWidth: 0, maxWidth: UIScreen.screenWidth - 15)
                .padding(5)
        }
    }
}

struct MegaWalletCoinView_Previews: PreviewProvider {
    static var previews: some View {
        MegaWalletCoinView()
    }
}

