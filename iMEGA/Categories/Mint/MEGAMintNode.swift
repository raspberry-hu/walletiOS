//
//  MEGAMintNode.swift
//  MEGA
//
//  Created by hu on 2022/03/04.
//  Copyright © 2022 MEGA. All rights reserved.
//

import SwiftUI
import Combine
import TTProgressHUD

@available(iOS 15.0, *)
@available(iOSApplicationExtension 15.0, *)
struct HUD: View {
    @State var text:String
    @ViewBuilder var body: some View {
        Text(text)
            .foregroundColor(.gray)
            .padding(.horizontal, 10)
            .padding(14)
            .background(
                Blur(style: .systemMaterial)
                    .clipShape(Capsule())
                    .shadow(color: Color(.black).opacity(0.22), radius: 12, x: 0, y: 5)
            )
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
struct MEGAMintNode: View {
    @EnvironmentObject var mintModel: MintModel
    @State var showCollection = false
    @State var hudConfig = TTProgressHUDConfig()
    var body: some View {
        ZStack(alignment: .top) {
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
                    } header: {
                        HStack{
                            Text("Mint Message")
                        }
                    }
                    if(showCollection) {
                        Section {
                            Picker(selection: $mintModel.mintCollectionCount) {
                                ForEach(0..<self.mintModel.mintCollectionCount) {
                                    Text(self.mintModel.mintCollectionArray[$0])
                                }
                            } label: {
                                Text("Collection")
                            }
                            .pickerStyle(.menu)
                        } header: {
                            Text("Select Collection")
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
                        mintModel.mintHUD = true
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
                .alert(isPresented: self.$mintModel.mintSuccess) {
                    Alert(title: Text("MegaWallet"), message: Text("Mint Success"), dismissButton: .default(Text("OK")))
                }
                .alert(isPresented: self.$mintModel.mintFail) {
                    Alert(title: Text("MegaWallet"), message: Text("Mint Fail"), dismissButton: .default(Text("OK")))
                }
            }
            .onLoad {
                self.mintModel.mintHUD = false
                Task {
                    await self.mintModel.NFTUpdateCollection()
                    showCollection = true
                }
            }
//            TTProgressHUD(self.$mintModel.mintHUD, config: hudConfig)
            HUD(text: "Minting")
                .offset(y: self.mintModel.mintHUD ? 0 : -100)
                .animation(.easeInOut)
        }
    }
}

