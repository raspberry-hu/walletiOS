//
//  URLRequestBuilder.swift
//  MEGA
//
//  Created by raspberry on 2022/5/6.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public typealias Parameters = [String: String]
public typealias HTTPHeaders = [String: String]

public protocol URLRequestBuilder {
    var baseURL: URL { get }
    var requestURL: URL { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
    var urlRequest: URLRequest { get }
}

extension URLRequestBuilder {

    public var requestURL: URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = path
        if method == .get {
            components.queryItems = parameters?.compactMap({
                URLQueryItem(name: $0.key, value: $0.value)
            })
        }
        return components.url!
    }

    public var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        if method != .get, let parameters = parameters {
            let params = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = params
        }
        headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        return request
    }

}

