//
//  MegaWalletNFTEventDetailSubView.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI

struct MegaWalletNFTEventDetailSubView: View {
    @EnvironmentObject var store: Store
    var body: some View {
//        NavigationView {
            List {
                ForEach(0..<(store.appState.NFTEvent.NFTEventDetail?.msg.count)!) { index in
//                    NavigationLink {
//
//                    } label: {
//                        Text((store.appState.NFTEvent.NFTEventDetail?.msg[index].eventType)!)
//                    }
                    NavigationLink(destination: MegaWalletNFTEventDetailSubestView(eventType: (store.appState.NFTEvent.NFTEventDetail?.msg[index].eventType)!, price: (store.appState.NFTEvent.NFTEventDetail?.msg[index].endingPrice), fromAccount: (store.appState.NFTEvent.NFTEventDetail?.msg[index].fromAccount), toAccount: (store.appState.NFTEvent.NFTEventDetail?.msg[index].toAccount), date: (store.appState.NFTEvent.NFTEventDetail?.msg[index].createdDate)!)) {
                        Text((store.appState.NFTEvent.NFTEventDetail?.msg[index].eventType)!)
                    }
                }
            }
//        }
        .listStyle(GroupedListStyle())
        .navigationTitle(Text("事件信息"))
//        .onDisappear {
//            store.appState.NFTEvent.NFTEventDetail = nil
//        }
    }
}
struct MegaWalletNFTEventDetailSubestView: View {
    let eventType: String
    let price: String?
    let fromAccount: Owner?
    let toAccount: Owner?
    let date: String
    var body: some View {
        List {
            Section(header: Text("Event Type")) {
//                ForEach(0 ..< 1) {_ in
//                    Text(eventType)
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white.opacity(1))
                        .frame(minWidth: 0, maxWidth: UIScreen.screenWidth * 0.9, minHeight: 0, maxHeight: UIScreen.screenWidth * 0.1)
                        .shadow(radius: 2)
                    Text(eventType)
                }
//                }
            }
            Section(header: Text("Price(Eth)")) {
                if price == nil {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white.opacity(1))
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth * 0.9, minHeight: 0, maxHeight: UIScreen.screenWidth * 0.1)
                            .shadow(radius: 2)
                        Text("Null")
                    }
                } else {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white.opacity(1))
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth * 0.9, minHeight: 0, maxHeight: UIScreen.screenWidth * 0.1)
                            .shadow(radius: 2)
                        Text(String(Double(price!)! / 1000000000000000000))
                    }
                }
            }
            Section(header: Text("From Address")) {
                if fromAccount == nil {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white.opacity(1))
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth * 0.9, minHeight: 0, maxHeight: UIScreen.screenWidth * 0.1)
                            .shadow(radius: 2)
                        Text("Null")
                    }
                } else {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white.opacity(1))
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth * 0.9, minHeight: 0, maxHeight: UIScreen.screenWidth * 0.1)
                            .shadow(radius: 2)
                        Text(fromAccount!.address)
                    }
                }
            }
            Section(header: Text("To Address")) {
                if toAccount == nil {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white.opacity(1))
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth * 0.9, minHeight: 0, maxHeight: UIScreen.screenWidth * 0.1)
                            .shadow(radius: 2)
                        Text("Null")
                    }
                } else {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white.opacity(1))
                            .frame(minWidth: 0, maxWidth: UIScreen.screenWidth * 0.9, minHeight: 0, maxHeight: UIScreen.screenWidth * 0.1)
                            .shadow(radius: 2)
                        Text(toAccount!.address)
                    }
                }
            }
            Section(header: Text("Date")) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white.opacity(1))
                        .frame(minWidth: 0, maxWidth: UIScreen.screenWidth * 0.9, minHeight: 0, maxHeight: UIScreen.screenWidth * 0.1)
                        .shadow(radius: 2)
                    Text("\(date[0...10]) \(date[12...19])")
                }
            }
        }
    }
}

extension String {
    subscript(_ indexs: ClosedRange<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex...endIndex])
    }
    
    subscript(_ indexs: Range<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex..<endIndex])
    }
    
    subscript(_ indexs: PartialRangeThrough<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex...endIndex])
    }
    
    subscript(_ indexs: PartialRangeFrom<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        return String(self[beginIndex..<endIndex])
    }
    
    subscript(_ indexs: PartialRangeUpTo<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex..<endIndex])
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

