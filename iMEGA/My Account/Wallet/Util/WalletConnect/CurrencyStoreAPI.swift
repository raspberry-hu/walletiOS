//
//  CurrencyStoreAPI.swift
//  MEGA
//
//  Created by raspberry on 2022/5/6.
//  Copyright © 2022 MEGA. All rights reserved.
//

public enum CurrencyStoreAPI: URLRequestBuilder {
    case currencies
}

extension CurrencyStoreAPI {
    public var baseURL: URL {
        return URL(string: "https://api.coingecko.com")!
    }

    public var path: String {
        switch self {
        case .currencies:
            return
                "/api/v3/simple/price"
        }
    }

    public var headers: HTTPHeaders {
        switch self {
        case .currencies:
            return ["Accept": "application/json"]
        }
    }

    public var parameters: Parameters? {
        switch self {
        case .currencies:
            return [
                "ids": "ethereum,matic-network,usd-coin,tether,shiba-inu",
                "vs_currencies": "usd",
                "include_24hr_change": "true",
                "include_last_updated_at": "true",
            ]
        }
    }

    public var method: HTTPMethod {
        return .get
    }
}
