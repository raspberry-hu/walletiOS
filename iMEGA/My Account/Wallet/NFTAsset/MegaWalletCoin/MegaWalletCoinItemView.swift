//
//  MegaWalletCoinItemView.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI
import Kingfisher

@available(iOS 14.0, *)
struct MegaWalletCoinItemView: View {
    @EnvironmentObject var store: Store
    let number: Int
    var body: some View {
        if (store.appState.megaWalletCoin.coinDetail != nil)&&(store.appState.megaWalletCoin.coinPrice != nil)&&(store.appState.megaWalletCoin.requesting != false) {
            HStack {
                KFImage(URL(string: store.appState.megaWalletCoin.coinDetail![number].logoURL!))
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: 5) {
                    Text(store.appState.megaWalletCoin.coinDetail![number].fullname!)
                        .font(.system(size: 20, design: .default))
                    Text("0 \(String(store.appState.megaWalletCoin.coinDetail![number].slug!))")
                        .font(.system(size: 15, weight: .light, design: .default))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    Text("$\(String(store.appState.megaWalletCoin.coinPrice![number].u!))")
                    if(store.appState.megaWalletCoin.coinPrice![number].c! > 0) {
                        HStack(spacing: 3) {
                            Text("\(String(store.appState.megaWalletCoin.coinPrice![number].c! * 100))%")
                                .foregroundColor(.green)
                                .font(.system(size: 15, weight: .light, design: .default))
                            Image(systemName: "arrowtriangle.up.fill")
                                .foregroundColor(.green)
                        }
                    } else {
                        HStack {
                            Text("\(String(store.appState.megaWalletCoin.coinPrice![number].c! * 100))%")
                                .foregroundColor(.red)
                                .font(.system(size: 15, weight: .light, design: .default))
                            Image(systemName: "arrowtriangle.down.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        } else {
            HStack {
                Image(systemName: "photo.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: 5) {
                    Text("fail")
                        .font(.system(size: 20, design: .default))
                        .redacted(reason: .placeholder)
                    Text("fail")
                        .font(.system(size: 15, weight: .light, design: .default))
                        .redacted(reason: .placeholder)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    Text("fail")
                        .redacted(reason: .placeholder)
                    HStack {
                        Text("fail")
                            .foregroundColor(.red)
                            .font(.system(size: 15, weight: .light, design: .default))
                            .redacted(reason: .placeholder)
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(.red)
                            .redacted(reason: .placeholder)
                    }
                }
            }
        }
    }
}

