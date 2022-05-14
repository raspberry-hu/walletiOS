//
//  MintModel.swift
//  MEGA
//
//  Created by hu on 2022/04/26.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation
import Defaults
@available(iOS 15.0, *)

struct mintInfoUpload: Codable {
    var tokenId: [Int]
    var nft_name: String
    var description: String
    var image: String
    var external_link: String
    var input_arr: String
    var mint_num: String
    var walletaddress: String
}

class MintModel: ObservableObject {
    @Published var publicLink:String = ""
    @Published var mintName:String = ""
    @Published var mintdescription:String = ""
    @Published var externalLink:String = ""
    @Published var chain = ["Ethereum", "Rinkeby", "Polygon"]
    @Published var selectedChain: Int = 0
    @Published var name = ""
    @Published var mintCount: String = ""
    @Published var mintFail = false
    @Published var mintSuccess = true
    @Published var mintCollectionArray = ["None Collection"]
    @Published var mintCollectionSelection = 0
    @Published var mintCollectionCount = 0
    @Published var mintHUD = false
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()

//    func encoder(loan: mintInfoUpload) -> String?{
//        do  {
//            let data: Data = try encoder.encode(loan)
//            let json_string = String(data: data, encoding: String.Encoding.utf8) ?? ""
//            print(data)
//            print(String(data: data, encoding: String.Encoding.utf8) as Any)
//            print(loan)
//            return json_string
//        } catch {
//            print(error)
//        }
//        return nil
//    }
    
    func NFTMintRequest() async {
        let session = URLSession(configuration: .default)
        let url = "http://47.254.43.21:8655/api/mint"
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postData = ["network":"rinkeby","owner_address":Defaults[.walletNowAddress],"mint_number":Int(self.mintCount)!] as [String : Any]
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        var tokenidArray = [Int]()
        do {
            print("开始铸币0")
            let (responseData, response) = try await session.data(for: request)
            print(response)
            print(responseData)
            let r = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            print("开始铸币1")
            print(r)
            if (r.value(forKey: "code") as! Int) == 200 {
                let hashArray = r.value(forKey: "msg") as! [String]
                for hashValue in hashArray {
                    let subSession = URLSession(configuration: .default)
                    let subUrl = "http://47.254.43.21:8655/api/getTokenId"
                    var subRequest = URLRequest(url: URL(string: subUrl)!)
                    subRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    subRequest.httpMethod = "POST"
                    let postData = ["hash": hashValue] as [String : Any]
                    let postString = postData.compactMap({ (key, value) -> String in
                        return "\(key)=\(value)"
                    }).joined(separator: "&")
                    subRequest.httpBody = postString.data(using: .utf8)
                    let (responseData, response) = try await session.data(for: subRequest)
                    let subR = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print(subR)
                    let tokenid = subR.value(forKey: "msg") as! String
                    tokenidArray.append(Int(tokenid)!)
                }
                let finalSession = URLSession(configuration: .default)
                let finalUrl = "http://47.254.43.21:8090/api/mint"
                var finalRequest = URLRequest(url: URL(string: url)!)
                finalRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                finalRequest.httpMethod = "POST"
                let mintupload = mintInfoUpload(tokenId: tokenidArray, nft_name: self.mintName, description: self.mintdescription, image: self.publicLink, external_link: self.externalLink, input_arr: self.mintCollectionArray[self.mintCollectionCount], mint_num: self.mintCount, walletaddress: Defaults[.walletNowAddress])
                let data: Data = try encoder.encode(mintupload)
                let jsonString = String(data: data, encoding: String.Encoding.utf8) ?? ""
                print("开始铸币2")
                print(jsonString)
                let finalPostData = ["data":jsonString] as [String : Any]
                let finalPostString = finalPostData.compactMap({ (key, value) -> String in
                    return "\(key)=\(value)"
                }).joined(separator: "&")
                finalRequest.httpBody = finalPostString.data(using: .utf8)
                let (finalResponseData, finalResponse) = try await finalSession.data(for: finalRequest)
                let subR = try JSONSerialization.jsonObject(with: finalResponseData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print("开始铸币3")
                print(subR)
                DispatchQueue.main.async {
                    self.mintSuccess = true
                    self.mintHUD = false
                }
            } else {
                DispatchQueue.main.async {
                    self.mintFail = true
                    self.mintHUD = false
                }
            }
        } catch {
            print("无法连接到服务器")
            DispatchQueue.main.async {
                self.mintFail = true
                self.mintHUD = false
            }
        }
    }
    func NFTUpdateCollection() async {
        let session = URLSession(configuration: .default)
        let url = "http://47.254.43.21:8655/api/getCollectionsName"
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postData = ["owner":Defaults[.walletNowAddress],"limit":20] as [String : Any]
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        do {
            let (responseData, response) = try await session.data(for: request)
            let r = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            DispatchQueue.main.async {
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


