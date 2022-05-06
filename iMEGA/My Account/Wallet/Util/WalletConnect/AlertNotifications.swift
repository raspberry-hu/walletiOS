//
//  AlertNotifications.swift
//  MEGA
//
//  Created by raspberry on 2022/5/5.
//  Copyright © 2022 MEGA. All rights reserved.
//

//
//  AlertNotification.swift
//  WalletConnect
//
//  Created by raspberry on 2022/4/22.
//

import Foundation

class AlertManager: ObservableObject {
    enum ActiveAlert {
        case showingDefault
        case showingdidDisconnect
        case showingdidFailToConnect
        case showingshouldStart
        case showingAskToSign
        case showingAskTotransact
        case showingConnectWallet
    }
    @Published var showingAlert = false
    @Published var activeAlert: ActiveAlert = .showingDefault
    @Published var semaphore = DispatchSemaphore(value: 0)
    @Published var reject:Bool = true
    static let sharedAlertInstance = AlertManager()
    func showingAlertChange(change:Bool) {
        AlertManager.sharedAlertInstance.showingAlert = change
    }
    private init() {
    }
}


