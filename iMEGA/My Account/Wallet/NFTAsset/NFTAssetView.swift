//
//  NFTAssetView.swift
//  MEGA
//
//  Created by hu on 2022/03/22.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI
import Defaults
import web3swift
import WalletConnectSwift
import SheetKit
import BigInt

@available(iOS 14.0, *)
struct NFTAssetView: View {
    @EnvironmentObject var web3Model: Web3Model
    @EnvironmentObject var store: Store
    private var walletOptions = ["Currency", "NFT", "Market"]
    @State private var selctedItem: Int = 0
    @State private var searchText: String = ""
    @State private var showSend = false
    @State private var walletAddress = ""
    @State private var walletCount = ""
    @State private var sendReturn = ""
    @State private var showSendResponse = false
    @MainActor
    private func send() async{
        let web3 = web3Model.wallet?.web3
        let walletAddress = EthereumAddress(Defaults[.walletNowAddress])!
        let balanceResult = try! web3!.eth.getBalance(address: walletAddress)
        let balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 3)!
        let value: String = self.walletCount // In Ether
        let toAddress = EthereumAddress(self.walletAddress)!
        let contract = web3!.contract(Web3.Utils.coldWalletABI, at: toAddress, abiVersion: 2)!
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        var options = TransactionOptions.defaultOptions
        options.value = amount
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .manual(BigUInt(21000))
        let tx = contract.write(
            "fallback",
            parameters: [AnyObject](),
            extraData: Data(),
            transactionOptions: options)!
        do{
            let result = try await tx.send(password: "web3swift").transaction.hash!.toHexString()
            self.sendReturn = result
            self.showSendResponse = true
            self.showSend = false
            print(result)
        }catch {
            self.sendReturn = "Fail"
            self.showSendResponse = true
            self.showSend = true
        }
    }
    var body: some View {
        ZStack(alignment: .top) {
        VStack {
            VStack {
                MegaWalletRootViewSearch(searchText: $searchText)
                    .frame(width:UIScreen.screenWidth * 0.95 , height: UIScreen.screenWidth / 12)
                    .padding(.top, 8)
                HStack {
                    Text("Address: ")
                    Text(web3Model.publicAddress.prefix(6))
                    Text("Send")
                        .onTapGesture {
                            SheetKit().present(with: .bottomSheet) {
                                VStack {
                                    TextField("Enter Address", text: self.$walletAddress)
                                        .modifier(textFieldModify())
                                    TextField("Enter Count", text: self.$walletCount)
                                        .modifier(textFieldModify())
                                    Button {
                                        self.showSend = true
                                    } label: {
                                        Text("Ok")
                                    }
                                }
                            }
                        }
                    Spacer()
                    Text("Balance: $\(web3Model.balanceFor(TokenType.ether) ?? "0")")
                        .padding()
                }
                .frame(width:UIScreen.screenWidth * 0.93)
                Section(){
                    Picker("Gender", selection: $selctedItem) {
                        ForEach(0..<walletOptions.count) {
                            Text(self.walletOptions[$0])
                        }
                    }.pickerStyle( SegmentedPickerStyle())
                }
                .padding()
                if selctedItem == 0 {
                    MegaWalletCoinView()
                }
                if selctedItem == 1 {
                    MegaWalletNFTRootView(NFTAsset: store.appState.NFTAsset.NFTAssetImage)
                }
                if selctedItem == 2 {
                    MegaWalletOpenSeaRootView()
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .alert(isPresented: self.$showSendResponse) {
                Alert(title: Text("MegaWallet"), message: Text(self.sendReturn), dismissButton: .default(Text("OK")))
            }
        }
        HUD(text: "Sending")
            .offset(y: self.showSend ? 0 : -100)
            .animation(.easeInOut)
    }
    }
}

struct MegaWalletRootViewSearch: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack{
            HStack{
                Image(systemName: "magnifyingglass")
                    .padding(.leading, 10)
                TextField("Search", text: $searchText)
            }
            .frame(height: 30)
            .background(Color("E6E6E6"))
            .cornerRadius(40)
            Text("Cancle")
        }
    }
}
