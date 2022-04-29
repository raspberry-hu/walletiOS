//
//  walletCreateView.swift
//  MEGA
//
//  Created by hu on 2022/04/28.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI

struct walletCreateView: View {
    @EnvironmentObject var web3Model: Web3Model
    @State var textPasswordVerify: String = ""
    @State private var showingPasswordAlert = false
    var body: some View {
        VStack(alignment: .leading,spacing: 15){
            ZStack(alignment: .leading) {
                Text("警告：切勿向他人透露您的账户助记词")
            }
            TextField("输入名称", text: self.$web3Model.walletDetailsModel.walletName)
            SecureField("输入密码", text: self.$web3Model.walletDetailsModel.walletPassword)
            SecureField("重复密码", text: $textPasswordVerify)
            Button {
                print("")
            } label: {
                Text("Create Wallet")
                    .frame(width: UIScreen.screenWidth * 0.9 , height: UIScreen.screenWidth / 10, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color("00C29A"))
                    .cornerRadius(10)
            }
            .alert(isPresented: $showingPasswordAlert) {
                Alert(title: Text("创建失败"), message: Text("请输入相同的密码"), dismissButton: .default(Text("OK")))
            }
            Spacer()
        }
    }
}
