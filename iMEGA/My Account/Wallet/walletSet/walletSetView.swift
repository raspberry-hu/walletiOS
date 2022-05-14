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
                NavigationLink(destination: walletCreateView(completion: self.walletCreate).environmentObject(web3Model)) {
                    Image("WalletCreate")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Create Wallet")
                }
                .frame(height: 45)
                NavigationLink(destination: walletImportView(completion: self.walletImport).environmentObject(web3Model)) {
                    Image("WalletImport")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Import Wallet")
                }
                .frame(height: 45)
                NavigationLink(destination: walletManageView().environmentObject(web3Model)) {
                    Image("WalletAddress")
                        .resizable()
                        .frame(width: 20, height: 15)
                    Text("Manage Wallet")
                }
                .frame(height: 45)
            }
    }
    private func walletCreate() -> () {
        print("wallet create")
    }
    private func walletImport() -> () {
        print("wallet import")
    }
}

struct walletSetView_Previews: PreviewProvider {
    static var previews: some View {
        walletSetView()
    }
}

