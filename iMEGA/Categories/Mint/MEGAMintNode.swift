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
            Text(mintModel.publicLink)
            Text(mintModel.MintName)
        }
    }
}

