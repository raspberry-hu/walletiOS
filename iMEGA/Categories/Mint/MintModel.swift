//
//  MintModel.swift
//  MEGA
//
//  Created by hu on 2022/04/26.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation

@available(iOS 15.0, *)
class MintModel: ObservableObject {
    @Published var publicLink:String = ""
    @Published var mintName:String = ""
    @Published var mintdescription:String = ""
    @Published var externalLink:String = ""
    @Published var chain = ["Ethereum", "Rinkeby", "Polygon"]
    @Published var selectedChain: Int = 0
    @Published var name = ""
    @Published var mintCount: String = ""
    @Published var mintCollection: String = ""
    @Published var mintFail = false
    @Published var mintSuccess = true
    @Published var mintCollectionArray = ["None Collection"]
    @Published var mintCollectionCount = 1
    @available(iOSApplicationExtension 15.0, *)
    func NFTMintRequest() async {
        let session = URLSession(configuration: .default)
        let url = "http://47.254.43.21:8655/api/mint"
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postData = ["network":"rinkeby","owner_address":"0xcccA3b7c428A4b6FFae5022Ab3A0B57C531f3aD0","mint_number":3] as [String : Any]
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        do {
            let (responseData, response) = try await session.data(for: request)
            let r = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            self.mintSuccess = true
            print(r)
        } catch {
            print("无法连接到服务器")
            self.mintFail = true
        }
    }
    func NFTUpdateCollection() async {
        let session = URLSession(configuration: .default)
        let url = "http://47.254.43.21:8655/api/getCollectionsName"
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postData = ["owner":"0x6a22409c4e1dF5fcE2Ec74a5B70D222723e83066","limit":20] as [String : Any]
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        do {
            let (responseData, response) = try await session.data(for: request)
            let r = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            DispatchQueue.main.async {
                self.mintSuccess = true
                self.mintCollectionArray = r.value(forKey: "msg") as! [String]
                self.mintCollectionCount = self.mintCollectionArray.count
                print(self.mintCollectionCount)
                print(self.mintCollectionArray)
            }
            print(r)
        } catch {
            print("无法连接到服务器")
            self.mintFail = true
        }
    }
}


