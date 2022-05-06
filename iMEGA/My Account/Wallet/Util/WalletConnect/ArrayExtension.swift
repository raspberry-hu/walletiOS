//
//  ArrayExtension.swift
//  MEGA
//
//  Created by raspberry on 2022/5/5.
//  Copyright © 2022 MEGA. All rights reserved.
//

//
//  ArrayExtension.swift
//  WalletConnect
//
//  Created by hu on 2022/04/19.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    public subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element: Equatable {
    /// Returns this array, with all duplicate elements removed
    public func removeDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        return result
    }
}

extension ArraySlice {
    /// Convert an `ArraySlice` to an `Array`.
    /// Useful in a chaining context.
    public func toArray() -> [Element] {
        Array(self)
    }
}

extension Array {
    public mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
}
