//
//  Prefs.swift
//  MEGA
//
//  Created by hu on 2022/04/28.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation

extension Defaults.Keys {
    public static let cryptoPublicKey = Defaults.Key<String>("cryptoPublicKey", default: "")
    public static let cryptoTransactionHashStore = Defaults.Key<Set<String>>(
        "cryptoTransactionHashStore", default: [])
    public static let sessionsPeerIDs = Defaults.Key<Set<String>>(
        "web3SessionsPeerIDs", default: [])
    public static let tickerResponse = Defaults.Key<Data?>("tickerResponse", default: nil)
    public static let walletIntroSeen = Defaults.BoolKey("seenWalletIntro")
    public static let walletOnboardingDone = Defaults.BoolKey("walletOnboardingDone")
    public static let currentTheme = Defaults.Key<String>("currentTheme", default: "")
}
extension Defaults {
    static func BoolKey(
        _ key: String,
        default defaultValue: Bool = false,
        suite: UserDefaults = .standard
    ) -> Key<Bool> {
        Key<Bool>(key, default: defaultValue, suite: suite)
    }
}
