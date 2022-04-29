//
//  walletSetView.swift
//  MEGA
//
//  Created by hu on 2022/03/22.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI
import UIKit

struct walletSetView: View {
    @EnvironmentObject var web3Model: Web3Model
    var body: some View {
            List {
                NavigationLink(destination: walletCreateView().environmentObject(web3Model)) {
                    Image("WalletCreate")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Create Wallet")
                }
                .frame(height: 45)
                NavigationLink(destination: walletImportView()) {
                    Image("WalletImport")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Import Wallet")
                }
                .frame(height: 45)
                NavigationLink(destination: walletManageView()) {
                    Image("WalletAddress")
                        .resizable()
                        .frame(width: 20, height: 15)
                    Text("Manage Wallet")
                }
                .frame(height: 45)
            }
    }
}

struct walletSetView_Previews: PreviewProvider {
    static var previews: some View {
        walletSetView()
    }
}

