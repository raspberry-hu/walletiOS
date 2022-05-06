
import Defaults
import Foundation
import SwiftUI

public enum Currency: String, CaseIterable, Codable {
    case ETH, WETH, MATIC, SHIB, USDC, USDT

    public var name: String {
        switch self {
        case .ETH:
            return "Ether"
        case .WETH:
            return "Wrapped Ether"
        case .MATIC:
            return "Matic"
        case .SHIB:
            return "Shiba Inu"
        case .USDC:
            return "USD Coin"
        case .USDT:
            return "Tether"
        }
    }
}

struct TickerData: Codable {
    let usd: Double
    let usd_24h_change: Double
    let last_updated_at: Int
}

struct TickerResponse: Codable {
    let eth: TickerData
    let matic: TickerData
    let usdc: TickerData
    let usdt: TickerData
    let shib: TickerData

    enum CodingKeys: String, CodingKey {
        case eth = "ethereum"
        case matic = "matic-network"
        case usdc = "usd-coin"
        case usdt = "tether"
        case shib = "shiba-inu"
    }

    func tickerData(for coin: Currency) -> TickerData {
        switch coin {
        case .ETH:
            return eth
        case .WETH:
            return eth
        case .MATIC:
            return matic
        case .SHIB:
            return shib
        case .USDC:
            return usdc
        case .USDT:
            return usdt
        }
    }
}

public struct CurrencyStore {
    public static let shared = CurrencyStore()
    public func refresh() {
        guard
            let url = URL(
                string:
                    "https://api.coingecko.com/api/v3/simple/price?ids=ethereum%2Cmatic-network%2Cusd-coin%2Ctether%2Cshiba-inu&vs_currencies=usd&include_24hr_change=true&include_last_updated_at=true"
            )
        else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data else { return }

            guard let result = try? JSONDecoder().decode(TickerResponse.self, from: data) else {
                return
            }
            Defaults[.tickerResponse] = try! JSONEncoder().encode(result)
        }.resume()
    }

}

public enum TokenType: String, CaseIterable {
    case ether = "Ether"
    case wrappedEther = "Wrapped Ether"
    case matic = "Matic"
    case usdc = "USD Coin"
    case usdt = "Tether"
    case shib = "Shiba Inu"
    case wrappedEtherOnPolygon = "Wrapped Ether on Polygon"
    case maticOnPolygon = "Matic on Polygon"
    case usdcOnPolygon = "USD Coin on Polygon"
    case usdtOnPolygon = "Tether on Polygon"

    public var network: EthNode {
        switch self {
        case .ether:
            return .Ethereum
        case .wrappedEther:
            return .Ethereum
        case .matic:
            return .Ethereum
        case .usdc:
            return .Ethereum
        case .usdt:
            return .Ethereum
        case .shib:
            return .Ethereum
        case .wrappedEtherOnPolygon:
            return .Polygon
        case .maticOnPolygon:
            return .Polygon
        case .usdcOnPolygon:
            return .Polygon
        case .usdtOnPolygon:
            return .Polygon
        }
    }

    var conversionRateToUSD: Double {
        guard let tickerObject = Defaults[.tickerResponse],
            let response = try? JSONDecoder().decode(TickerResponse.self, from: tickerObject)
        else {
            return 0
        }
        return response.tickerData(for: self.currency).usd
    }

    public func toUSD(_ amount: String) -> String {
        if let value = Double(amount) {
            let usd = value * conversionRateToUSD
            return String(format: "%.\(usd < 0.01 ? 3 : 2)f", value * conversionRateToUSD)
        }
        return "N/A"
    }

    var contractAddress: String {
        switch self {
        case .ether:
            return ""
        case .wrappedEther:
            return "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
        case .matic:
            return "0x7d1afa7b718fb893db30a3abc0cfc608aacfebb0"
        case .usdc:
            return "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
        case .usdt:
            return "0xdac17f958d2ee523a2206206994597c13d831ec7"
        case .shib:
            return "0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce"
        case .wrappedEtherOnPolygon:
            return "0x7ceb23fd6bc0add59e62ac25578270cff1b9f619"
        case .maticOnPolygon:
            return ""
        case .usdcOnPolygon:
            return "0x2791bca1f2de4661ed88a30c99a7a9449aa84174"
        case .usdtOnPolygon:
            return "0xc2132d05d31c914a87c6611c10748aeb04b58e8f"
        }
    }

    public var currency: Currency {
        switch self {
        case .ether:
            return .ETH
        case .wrappedEther:
            return .WETH
        case .matic:
            return .MATIC
        case .usdc:
            return .USDC
        case .usdt:
            return .USDT
        case .shib:
            return .SHIB
        case .wrappedEtherOnPolygon:
            return .WETH
        case .maticOnPolygon:
            return .MATIC
        case .usdcOnPolygon:
            return .USDC
        case .usdtOnPolygon:
            return .USDT
        }
    }
}
