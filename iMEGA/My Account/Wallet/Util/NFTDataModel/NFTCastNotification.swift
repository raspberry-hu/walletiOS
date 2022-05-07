//
//  NFTCastNotification.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation

class NFTCastNotification: ObservableObject {
    @Published var mintName: String
    @Published var mintNumber: Int
    @Published var mintDescription: String
    @Published var mintExternalLink: String
    @Published var mintCollection: String
    static let sharedNFTCast = NFTCastNotification()
    func reset() {
        self.mintCollection = ""
        self.mintName = ""
        self.mintDescription = ""
        self.mintNumber = 0
        self.mintExternalLink = ""
    }
    private init() {
        self.mintCollection = ""
        self.mintName = ""
        self.mintDescription = ""
        self.mintNumber = 0
        self.mintExternalLink = ""
    }
}
