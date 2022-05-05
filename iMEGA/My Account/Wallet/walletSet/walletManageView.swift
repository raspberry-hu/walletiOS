//
//  walletManageView.swift
//  MEGA
//
//  Created by hu on 2022/04/28.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI
import Defaults

struct walletManageView: View {
    let walletmanage = walletManage()
    @State private var walletShowMnemonics = false
    @State private var walletSelectedAddress = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("wallet Address")
                .padding(.leading, 20)
                .padding(.top,20)
                .font(.system(size: 25, weight: .bold, design: .default))
            RadioButtonGroup(selectedId: Defaults[.walletNowAddress]){ selected in
                print("Selected is: \(selected)")
                walletSelectedAddress = selected
            }.environmentObject(walletmanage)
            Button {
                self.walletShowMnemonics = true
            } label: {
                Text("Import Wallet")
                    .frame(width: UIScreen.screenWidth * 0.9 , height: UIScreen.screenWidth * 0.1, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color("00C29A"))
                    .cornerRadius(10)
            }
            .alert(isPresented: $walletShowMnemonics) {
                Alert(title: Text("MegaWallet"), message: Text("\(MEGAWalletConstants.cryptoKeychain[string: "secretPhrase\(self.walletSelectedAddress)"] ?? "No secretPhase")"), dismissButton: .default(Text("OK")))
            }
            Spacer()
        }
        .onLoad {
            walletmanage.viewWalletAddressUpdate()
        }
    }
}

struct ColorInvert: ViewModifier {

    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        Group {
            if colorScheme == .dark {
                content.colorInvert()
            } else {
                content
            }
        }
    }
}

struct RadioButton: View {

    @Environment(\.colorScheme) var colorScheme

    let id: String
    let callback: (String)->()
    let selectedID : String
    let size: CGFloat
    let color: Color
    let textSize: CGFloat

    init(
        _ id: String,
        callback: @escaping (String)->(),
        selectedID: String,
        size: CGFloat = 20,
        color: Color = Color("00C29A"),
        textSize: CGFloat = 14
        ) {
        self.id = id
        self.size = size
        self.color = color
        self.textSize = textSize
        self.selectedID = selectedID
        self.callback = callback
    }

    var body: some View {
        Button(action:{
            self.callback(self.id)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Text(id)
                    .font(Font.system(size: textSize))
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: self.selectedID == self.id ? "largecircle.fill.circle" : "circle")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                    .modifier(ColorInvert())
            }.foregroundColor(self.color)
        }
        .foregroundColor(self.color)
        .padding()
    }
}

struct RadioButtonGroup: View {

    @State var selectedId: String = ""
    @EnvironmentObject var walletmanage: walletManage
    let callback: (String) -> ()
    var body: some View {
        List {
            ForEach(walletmanage.walletAddress, id: \.self) { entity in
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                    RadioButton(entity, callback: self.radioGroupCallback, selectedID: selectedId)
                }
            }
            .onDelete { offset in
                walletmanage.walletAddress.remove(atOffsets: offset)
                walletmanage.walletAddressUpdate()
            }
        }
    }

    func radioGroupCallback(id: String) {
        selectedId = id
        walletmanage.walletNowAddress = id
        walletmanage.walletAddressUpdate()
        print("切换主钱包成功\(id) UserDefaults存储为\(Defaults[.walletNowAddress])")
        callback(id)
    }
}
