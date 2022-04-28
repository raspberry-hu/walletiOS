//
//  MintModel.swift
//  MEGA
//
//  Created by hu on 2022/04/26.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation

class MintModel: ObservableObject {
    @Published var publicLink:String = ""
    @Published var mintName:String = ""
    @Published var mintdescription:String = ""
    @Published var externalLink:String = ""
    @Published var chain = ["Ethereum", "Rinkeby", "Polygon"]
    @Published var selectedChain: Int = 0
    @Published var name = ""
    @Published var mintCount: String = ""
    @Published var mintCollection: String = ""
}
