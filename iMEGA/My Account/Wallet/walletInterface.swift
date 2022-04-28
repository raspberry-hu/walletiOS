//
//  walletInterface.swift
//  MEGA
//
//  Created by hu on 2022/03/02.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation
import SwiftUI
import web3swift
@objc
class BoatDetailsInterface: NSObject {
    
    @objc func makeShipDetailsUI(_ name: String) -> UIViewController{
        var details = BoatDetailsView()
        details.shipName = name
        return UIHostingController(rootView: details)
    }
}
