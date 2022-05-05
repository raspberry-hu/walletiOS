//
//  MEGAWalletConstants.swift
//  MEGA
//
//  Created by raspberry on 2022/4/29.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Defaults
import Foundation
import KeychainAccess
import UIKit

public struct MEGAWalletConstants {
    public static let appGroup = "group." + AppInfo.baseBundleIdentifier
//    public static let appGroup = "group.mega.ios"
//    public static let keychain = Keychain(service: "MEGAWallet", accessGroup: appGroup)
    public static let cryptoKeychain = Keychain(service: "MEGAWallet")
        .accessibility(.whenUnlockedThisDeviceOnly)
}
