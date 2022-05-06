//
//  WalletServeManager.swift
//  MEGA
//
//  Created by raspberry on 2022/5/5.
//  Copyright © 2022 MEGA. All rights reserved.
//

//
//  WalletServeManager.swift
//  WalletConnect
//
//  Created by hu on 2022/04/19.
//

import Foundation
import web3swift
import WalletConnectSwift
import SwiftUI
import Defaults

//protocol ToastDelegate: AnyObject {
//    func shouldShowToast(for message: String)
//}

protocol WalletServerManagerDelegate: ResponseRelay {
//    func updateCurrentSession()
//    func updateCurrentSequence(_ sequence: SequenceInfo)
    var wallet: WalletAccessor? { get set }
}

class WalletServerManager: ObservableObject{
    @Published var alertManager = AlertManager.self
    var server: Server!
    var delegate: WalletServerManagerDelegate?
    var session: Session!
    let sessionKey = "sessionKey"
    init(delegate: WalletServerManagerDelegate) {
        self.delegate = delegate
        self.server = Server(delegate: self)
        registerToHandlers()
    }
    
    func registerToHandlers() {
        guard let delegate = delegate else { return }
        server.register(handler: PersonalSignHandler(relay: delegate))
        server.register(handler: SendTransactionHandler(relay: delegate))
        server.register(handler: SignTypedDataHandler(relay: delegate))
    }
}

extension WalletServerManager: ServerDelegate {
    func server(_ server: Server, didConnect session: Session) {
        LogService.shared.log(
            "WC: Did connect session to \(String(describing: session.dAppInfo.peerMeta.url))"
        )
        if let currentSession = self.session,
           currentSession.url.key != session.url.key {
            print("Test app only supports 1 session atm, cleaning...")
            try? self.server.disconnect(from: currentSession)
        }
        self.session = session
        let sessionData = try! JSONEncoder().encode(session)
        UserDefaults.standard.set(sessionData, forKey: sessionKey)
        guard !Defaults[.sessionsPeerIDs].contains(session.dAppInfo.peerId) else { return }
        Defaults[.dAppsSession(session.dAppInfo.peerId)] = try! JSONEncoder().encode(session)
        Defaults[.sessionsPeerIDs].insert(session.dAppInfo.peerId)
    }
    
    func server(_ server: Server, didDisconnect session: Session) {
        UserDefaults.standard.removeObject(forKey: sessionKey)
        LogService.shared.log(
            "WC: Did disconnect session to \(String(describing: session.dAppInfo.peerMeta.url))"
        )
        Defaults[.dAppsSession(session.dAppInfo.peerId)] = nil
        Defaults[.sessionsPeerIDs].remove(session.dAppInfo.peerId)
        DispatchQueue.main.async {
            self.alertManager.sharedAlertInstance.activeAlert = .showingdidDisconnect
            self.alertManager.sharedAlertInstance.showingAlert = true
            self.alertManager.sharedAlertInstance.semaphore.wait()
        }
    }
    
    func server(_ server: Server, didUpdate session: Session) {
        LogService.shared.log(
            "WC: Did update session to \(String(describing: session.dAppInfo.peerMeta.url))"
        )
        guard session.walletInfo!.approved else { return }
        Defaults[.dAppsSession(session.dAppInfo.peerId)] = try! JSONEncoder().encode(session)
        Defaults[.sessionsPeerIDs].insert(session.dAppInfo.peerId)
    }
    
    func server(_ server: Server, didFailToConnect url: WCURL) {
        LogService.shared.log("WC: Did fail to connect")
        DispatchQueue.main.async {
            self.alertManager.sharedAlertInstance.activeAlert = .showingdidFailToConnect
            self.alertManager.sharedAlertInstance.showingAlert = true
            self.alertManager.sharedAlertInstance.semaphore.wait()
        }
    }
    
    func server(_ server: Server, shouldStart session: Session, completion: @escaping (Session.WalletInfo) -> Void) {
        guard let wallet = delegate?.wallet else {
            let walletInfo = Session.WalletInfo(
                approved: false,
                accounts: [],
                chainId: session.dAppInfo.chainId ?? 4,
                peerId: UUID().uuidString,
                peerMeta: Session.ClientMeta(
                    name: "", description: "", icons: [], url: URL(string: "www.baidu.com")!)
            )
            completion(walletInfo)
            return
        }
        let walletMeta = Session.ClientMeta(name: "Test Wallet",
                                            description: nil,
                                            icons: [],
                                            url: URL(string: "https://safe.gnosis.io")!)
        let walletInfo = Session.WalletInfo(approved: true,
                                            accounts: [wallet.publicAddress],
                                            chainId: 4,
                                            peerId: UUID().uuidString,
                                            peerMeta: walletMeta)

        LogService.shared.log(
            "WC: Should Start from \(String(describing: session.dAppInfo.peerMeta.url)) and accounts \(wallet.publicAddress)"
        )
        DispatchQueue.main.async {
            self.alertManager.sharedAlertInstance.activeAlert = .showingshouldStart
            self.alertManager.sharedAlertInstance.showingAlert = true
            self.alertManager.sharedAlertInstance.semaphore.wait()
            LogService.shared.log(
                "33"
            )
            if (self.alertManager.sharedAlertInstance.reject) {
                LogService.shared.log(
                    "11"
                )
                completion(walletInfo)
            }else {
                let walletInfo = Session.WalletInfo(
                    approved: false,
                    accounts: [wallet.publicAddress],
                    chainId: session.dAppInfo.chainId ?? 4,
                    peerId: UUID().uuidString,
                    peerMeta: wallet.walletMeta)
                LogService.shared.log(
                    "22"
                )
                completion(walletInfo)
            }
        }
    }
}

