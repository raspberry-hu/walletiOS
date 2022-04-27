//
//  MEGAMintNodeInterface.swift
//  MEGA
//
//  Created by hu on 2022/03/04.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

@objc
class MEGAMintNodeInterface: NSObject, MEGARequestDelegate, ObservableObject {
    private var nodesToExportCount = 1
    let mintModel = MintModel()
    private func updateModel(forNode node: MEGANode) {
        mintModel.publicLink = node.publicLink ?? "NIL"
        mintModel.MintName = node.name ?? "NIL"
    }
    private func exportNode(node: MEGANode){
        MEGASdkManager.sharedMEGASdk().export(node, delegate: MEGAExportRequestDelegate.init(completion: { [self] (request) in
            SVProgressHUD.dismiss()
            guard let nodeUpdated = MEGASdkManager.sharedMEGASdk().node(forHandle: node.handle) else {
                return
            }
            self.updateModel(forNode: nodeUpdated)
            }, multipleLinks: nodesToExportCount > 1))
    }
    @objc func MEGAMintNodeInterfaceView(_ node: MEGANode) -> UIViewController{
//        if !node.isExported() {
            exportNode(node: node)
            self.mintModel.MintName = node.name ?? "NIL"
//        }
        let details = MEGAMintNode().environmentObject(mintModel)
        return UIHostingController(rootView: details)
    }
}


