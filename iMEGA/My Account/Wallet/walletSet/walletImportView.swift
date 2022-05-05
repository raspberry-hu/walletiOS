//
//  walletImportView.swift
//  MEGA
//
//  Created by hu on 2022/04/28.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI

struct walletImportView: View {
    let model = OnboardingModel()
    @EnvironmentObject var web3Model: Web3Model
    let completion: () -> Void
    @State var textMnemonicEditor: String = ""
    @State var textNameEditor: String = ""
    @State var textPasswordEditor: String = ""
    @State var textPasswordVerifyEditor: String = ""
    @State private var showingPasswordAlert = false
    @State private var showingWalletImportAlert = false
    @State private var showingWalletImportFalseAlert = false
    var body: some View {
            VStack(alignment: .leading,spacing: 15) {
                Text("Input your mnemonics")
//                    .padding(.trailing, UIScreen.screenWidth * 0.70)
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .padding(.top)
                TextView(text: $textMnemonicEditor)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                    .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenWidth * 0.3)
//                    .shadow(radius: 8)
                    .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color.black, lineWidth: 1))
                Text("Input name")
                    .padding(.trailing, UIScreen.screenWidth * 0.70)
                    .font(.system(size: 20, weight: .regular, design: .default))
                TextField("Name", text: $textNameEditor)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                    .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenWidth * 0.08)
                    .shadow(radius: 8)
                    .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color.black, lineWidth: 1))
                Text("Input password")
                    .padding(.trailing, UIScreen.screenWidth * 0.70)
                    .font(.system(size: 20, weight: .regular, design: .default))
                SecureField("Password",text: $textPasswordEditor)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                    .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenWidth * 0.08)
                    .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color.black, lineWidth: 1))
                    .shadow(radius: 8)
                Text("Repeat Password")
                    .padding(.trailing, UIScreen.screenWidth * 0.70)
                    .font(.system(size: 20, weight: .regular, design: .default))
                SecureField("Password",text: $textPasswordVerifyEditor)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                    .frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenWidth * 0.08)
                    .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color.black, lineWidth: 1))
                    .shadow(radius: 5)
                Button {
                    model.importWallet(inputPhrase: self.textMnemonicEditor) { bool in
                        if bool == true {
                            self.showingWalletImportAlert = true
                        }else {
                            self.showingWalletImportFalseAlert = true
                        }
                    }
                } label: {
                    Text("Import Wallet")
                        .frame(width: UIScreen.screenWidth * 0.9 , height: UIScreen.screenWidth * 0.1, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color("00C29A"))
                        .cornerRadius(10)
                }
                .alert(isPresented: $showingWalletImportFalseAlert) {
                    Alert(title: Text("MegaWallet"), message: Text("Import Fail"), dismissButton: .default(Text("OK")))
                }
                .alert(isPresented: $showingWalletImportAlert) {
                    Alert(title: Text("MegaWallet"), message: Text("Import Success"), dismissButton: .default(Text("OK")))
                }
                Spacer()
        }
    }
}
