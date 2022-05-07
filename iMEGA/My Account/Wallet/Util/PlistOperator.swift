//
//  PlistOperator.swift
//  MEGA
//
//  Created by hu on 2022/05/07.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation

class PlistOperator: ObservableObject {
    
    let userDefault = UserDefaults.standard
    var array = UserDefaults.standard.stringArray(forKey: "Array")
    
    func getCoinItem() -> [String]? {
        if(self.array != nil){
            return self.array
        } else {
            let array: Array = ["bitcoin","ethereum","dogecoin"]
            self.array = array
            userDefault.set(array, forKey: "Array")
            return array
        }
    }

    func addCoinItem(name: String) -> Bool {
        if (self.array == nil) {
            return false
        } else {
            self.array?.append(name)
            userDefault.set(self.array, forKey: "Array")
        }
        return true
    }

    func deleteCoinItem(name: String) -> Bool {
        if (self.array == nil) {
            return false
        } else {
            self.array = self.array!.filter{ $0 != name }
            userDefault.set(self.array, forKey: "Array")
        }
        return true
    }
}

