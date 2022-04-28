//
//  MintModel.swift
//  MEGA
//
//  Created by hu on 2022/04/26.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation

class MintModel: ObservableObject {
    @Published var publicLink = ""
    @Published var MintName = ""
    @Published var Mintdescription = ""
    @Published var externalLink = ""
    @Published var chain = ["Ethereum", "Rinkeby", "Polygon"]
    @Published var selectedChain: Int = 0
    @Published var Name = ""
}
