//
//  MEGAMintNode.swift
//  MEGA
//
//  Created by hu on 2022/03/04.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI
import Combine

@available(iOS 15.0, *)
@available(iOSApplicationExtension 15.0, *)
struct MEGAMintNode: View {
    @EnvironmentObject var mintModel: MintModel
    var body: some View {
        VStack {
            Form {
                Section {
                    Text(mintModel.name)
                } header: {
                    Text("Photo Name")
                }
                Section {
                    TextField("Mint Name", text: self.$mintModel.mintName)
                    TextField("Mint Number", text: self.$mintModel.mintCount)
                } header: {
                    HStack{
                        Text("*")
                            .foregroundColor(.red)
                            + Text("Mint Message")
                    }
                }
                Section {
                    TextField("Mint Description", text: self.$mintModel.mintdescription)
                    TextField("Mint External Link", text: self.$mintModel.externalLink)
                    TextField("Mint Collection", text: self.$mintModel.mintCollection)
                } header: {
                    HStack{
                        Text("Mint Message")
                    }
                }
                Section {
                    Picker(selection: $mintModel.selectedChain) {
                        ForEach(0..<self.mintModel.chain.count) {
                            Text(self.mintModel.chain[$0])
                        }
                    } label: {
                        Text("Chain")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                } header: {
                    Text("Select Chain")
                }
            }
            Button {
                Task {
                    await mintModel.NFTMintRequest()
                }
            } label: {
                Text("Mint")
                    .frame(width: UIScreen.screenWidth * 0.9 , height: UIScreen.screenWidth * 0.1, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color("00C29A"))
                    .cornerRadius(10)
                    .padding(.leading, UIScreen.screenWidth * 0.05)
            }
            .buttonStyle(MintButtonStyle())
            .alert(isPresented: self.$mintModel.mintSuccess) {
                Alert(title: Text("MegaWallet"), message: Text("Mint Success"), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: self.$mintModel.mintFail) {
                Alert(title: Text("MegaWallet"), message: Text("Mint Fail"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

