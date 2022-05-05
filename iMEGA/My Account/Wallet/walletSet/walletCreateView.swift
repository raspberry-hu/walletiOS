//
//  walletCreateView.swift
//  MEGA
//
//  Created by hu on 2022/04/28.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI

struct walletCreateView: View {
    let completion: () -> Void
    let model = OnboardingModel()
    @EnvironmentObject var web3Model: Web3Model
    @State var textPasswordVerify: String = ""
    @State var showingPasswordAlert = false
    @State var isCreatingWallet = false
    var body: some View {
        VStack(alignment: .leading,spacing: 15){
            ZStack(alignment: .leading) {
                Text("Warning: Never share your account mnemonic with others")
            }
            TextField("Enter Name", text: self.$web3Model.walletDetailsModel.walletName)
                .modifier(textFieldModify())
            SecureField("Enter Password", text: self.$web3Model.walletDetailsModel.walletPassword)
                .modifier(textFieldModify())
            SecureField("Repeat Password", text: $textPasswordVerify)
                .modifier(textFieldModify())
            Button {
                model.createWallet {
                    self.isCreatingWallet = true
                    completion()
                }
            } label: {
                Text("Create Wallet")
                    .frame(width: UIScreen.screenWidth * 0.9 , height: UIScreen.screenWidth * 0.1, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color("00C29A"))
                    .cornerRadius(10)
            }
            .alert(isPresented: $showingPasswordAlert) {
                Alert(title: Text("MegaWallet"), message: Text("Create Fail"), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $isCreatingWallet) {
                Alert(title: Text("MegaWallet"), message: Text("Create Success"), dismissButton: .default(Text("OK")))
            }
            Button {
                web3Model.clear()
            } label: {
                Text("Clear Wallet")
                    .frame(width: UIScreen.screenWidth * 0.9 , height: UIScreen.screenWidth * 0.1, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color("00C29A"))
                    .cornerRadius(10)
            }
            Spacer()
        }
    }
}
