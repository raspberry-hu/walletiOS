//
//  StringExtensions.swift
//  MEGA
//
//  Created by raspberry on 2022/5/5.
//  Copyright © 2022 MEGA. All rights reserved.
//

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import UIKit

extension String {
    public var looksLikeAURL: Bool {
        // The assumption here is that if the user is typing in a forward slash and there are no spaces
        // involved, it's going to be a URL. If we type a space, any url would be invalid.
        // See https://bugzilla.mozilla.org/show_bug.cgi?id=1192155 for additional details.
        self.contains("/") && !self.contains(" ")
    }

    public func escape() -> String? {
        // We can't guaruntee that strings have a valid string encoding, as this is an entry point for tainted data,
        // we should be very careful about forcefully dereferencing optional types.
        // https://stackoverflow.com/questions/33558933/why-is-the-return-value-of-string-addingpercentencoding-optional#33558934
        let queryItemDividers = CharacterSet(charactersIn: "?=&")
        let allowedEscapes = CharacterSet.urlQueryAllowed.symmetricDifference(queryItemDividers)
        return self.addingPercentEncoding(withAllowedCharacters: allowedEscapes)
    }

    public func unescape() -> String? {
        return self.removingPercentEncoding
    }

    /// Ellipsizes a String only if it's longer than `maxLength`
    /// ```
    /// "ABCDEF".ellipsize(4)
    /// // "AB…EF"
    /// ```
    /// - parameter maxLength: The maximum length of the String.
    /// - returns: A String with `maxLength` characters or less
    public func ellipsize(maxLength: Int) -> String {
        if (maxLength >= 2) && (self.count > maxLength) {
            // `+ 1` has the same effect as an int ceil
            let index1 = self.index(self.startIndex, offsetBy: (maxLength + 1) / 2)
            let index2 = self.index(self.endIndex, offsetBy: maxLength / -2)

            return String(self[..<index1]) + "…\u{2060}" + String(self[index2...])
        }
        return self
    }

    private var stringWithAdditionalEscaping: String {
        return self.replacingOccurrences(of: "|", with: "%7C")
    }

    public var asURL: URL? {
        // Neeva and NSURL disagree about the valid contents of a URL.
        // Let's escape | for them.
        // We'd love to use one of the more sophisticated CFURL* or NSString.* functions, but
        // none seem to be quite suitable.
        return URL(string: self) ?? URL(string: self.stringWithAdditionalEscaping)
    }

    /// Returns a new string made by removing the leading String characters contained
    /// in a given character set.
    public func stringByTrimmingLeadingCharactersInSet(_ set: CharacterSet) -> String {
        var trimmed = self
        while trimmed.rangeOfCharacter(from: set)?.lowerBound == trimmed.startIndex {
            trimmed.remove(at: trimmed.startIndex)
        }
        return trimmed
    }

    public func remove(_ string: String?) -> String {
        return self.replacingOccurrences(of: string ?? "", with: "")
    }

    public func isEmptyOrWhitespace() -> Bool {
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }

    ///   Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
    ///   - Parameter length: Desired maximum lengths of a string
    ///   - Parameter trailing: A 'String' that will be appended after the truncation.
    ///
    ///   - Returns: 'String' object.
    public func truncateTo(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }

//    public func trim() -> String {
//        return self.trimmingCharacters(in: .whitespacesAndNewlines)
//    }
}

