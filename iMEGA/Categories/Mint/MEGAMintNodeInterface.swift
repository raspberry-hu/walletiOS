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

@available(iOS 15.0, *)
@objc
class MEGAMintNodeInterface: NSObject, MEGARequestDelegate, ObservableObject {
    private var nodesToExportCount = 1
    let mintModel = MintModel()
    private func updateModel(forNode node: MEGANode) {
        mintModel.publicLink = node.publicLink ?? "nil"
        mintModel.name = node.name ?? "nil"
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
        exportNode(node: node)
        self.mintModel.name = node.name ?? "NIL"
//        DispatchQueue.main.async {
//            Task {
//                await self.mintModel.NFTUpdateCollection()
//            }
//        }
        let details = MEGAMintNode().environmentObject(mintModel)
        return UIHostingController(rootView: details)
    }
}


