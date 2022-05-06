import Defaults
import Foundation
import secp256k1
import web3swift

struct Wallet {
    let address: String
    let data: Data
    let name: String
    let isHD: Bool
}

public enum ViewState {
    case xyzIntro
    case starter
    case dashboard
    case showPhrases
    case importWallet
}

public struct HDKey {
    let name: String?
    let address: String
}

public enum TransactionAction: String {
    case Receive
    case Send
}

public struct TransactionDetail: Hashable {
    let transactionAction: TransactionAction
    let amountInEther: String
    let oppositeAddress: String
}

public enum EthNode: String, CaseIterable, Identifiable {
    // real eth network
    case Ethereum
    // testing network
    case Ropsten
    // polygon network
    case Polygon

    public var id: Int {
        switch self {
        case .Ethereum:
            return 1
        case .Ropsten:
            return 3
        case .Polygon:
            return 137
        }
    }

    public static func from(chainID: Int?) -> EthNode {
        return allCases.first(where: { $0.id == chainID }) ?? .Ethereum
    }

    private var configKey: String {
        switch self {
        case .Ethereum:
            return "https://mainnet.infura.io/v3/f0ed4e15298d4dbba744d8472b0f1f01"
        case .Ropsten:
            return "https://ropsten.infura.io/v3/f0ed4e15298d4dbba744d8472b0f1f01"
        case .Polygon:
            return "https://polygon-mainnet.g.alchemy.com/v2/PrtiW3ArB5SPfodgiGYsM-weRlo-TPhZ"
        }
    }

    public var url: URL? {
        URL(string: configKey)
    }

    public var currency: TokenType {
        switch self {
        case .Ethereum:
            return .ether
        case .Ropsten:
            return .ether
        case .Polygon:
            return .maticOnPolygon
        }
    }
}

public class CryptoConfig {
    public let currentNode: EthNode

    public static let shared = CryptoConfig()

    public init() {
        // modify currentNode to switch between
        // real and testing eth network
        self.currentNode = .Ethereum
    }

    public var isOnTestingNetwork: Bool {
        self.currentNode == .Ropsten
    }

    public var password: String {
        return "NeevaCrypto"
    }

    public var walletName: String {
        return "My Neeva Crypto Wallet"
    }

    public func sendEth(
        with wallet: WalletAccessor?, amount: String, sendToAccountAddress: String,
        completion: () -> Void
    ) {
        guard let wallet = wallet else {
            completion()
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            _ = try? wallet.send(
                on: .Ethereum,
                transactionData: TransactionData(
                    from: wallet.publicAddress,
                    to: sendToAccountAddress,
                    value: nil,
                    data: nil,
                    gas: nil,
                    converted: Web3.Utils.parseToBigUInt(amount, units: .eth)
                )
            )
        }
        completion()
    }

    public struct AccountInfo {
        let balance: String
        let transactions: [TransactionDetail]
    }

    public func getData() -> AccountInfo {
        guard let web3 = try? Web3.new(EthNode.Ethereum.url ?? .aboutBlank) else {
            return AccountInfo(balance: "", transactions: [])
        }

        var transactionHistory: [TransactionDetail] = []
        var accountBalance = "0"
        do {
            let myAccountAddress = EthereumAddress("\(Defaults[.cryptoPublicKey])")!
            let balance = try web3.eth.getBalancePromise(address: myAccountAddress).wait()

            if let convertedBalance = Web3.Utils.formatToEthereumUnits(balance, decimals: 3) {
                accountBalance = convertedBalance
            }

            // print transaction history if available
            if Defaults[.cryptoTransactionHashStore].count > 0 {
                for hashStr in Defaults[.cryptoTransactionHashStore] {
                    let details = try web3.eth.getTransactionDetailsPromise(hashStr).wait()
                    let transactionValue = details.transaction.value
                    if let transactionInEther = Web3.Utils.formatToEthereumUnits(
                        transactionValue!, decimals: 3)
                    {
                        let toAddress = details.transaction.to.address
                        if toAddress == Defaults[.cryptoPublicKey] {
                            transactionHistory.append(
                                TransactionDetail(
                                    transactionAction: .Receive,
                                    amountInEther: transactionInEther,
                                    oppositeAddress: details.transaction.sender?.address ?? ""))
                        } else if let senderAddress = details.transaction.sender?.address {
                            if senderAddress == Defaults[.cryptoPublicKey] {
                                transactionHistory.append(
                                    TransactionDetail(
                                        transactionAction: .Send,
                                        amountInEther: transactionInEther,
                                        oppositeAddress: toAddress))
                            }
                        }

                    }
                }
            }
        } catch {
//            log.error("Unexpected get wallet data error: \(error).")
            print("Unexpected get wallet data error")
        }
        return AccountInfo(balance: accountBalance, transactions: transactionHistory)
    }
}
