//
//  MEGAMintNode.swift
//  MEGA
//
//  Created by hu on 2022/03/04.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI
import Combine

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
                print("this a button")
            } label: {
                Text("Mint")
            }
            .buttonStyle(MintButtonStyle())
        }
    }
}

