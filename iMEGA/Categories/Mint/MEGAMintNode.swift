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
        NavigationView {
            Form {
                Section {
                    Text(mintModel.MintName)
                } header: {
                    Text("Photo Name")
                }
                Section {
                    TextField("Mint Name", text: self.$mintModel.Name)
                    TextField("Mint Description", text: self.$mintModel.Mintdescription)
                    TextField("MInt External Link", text: self.$mintModel.externalLink)
                } header: {
                    Text("Mint Message")
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
        }
    }
}

