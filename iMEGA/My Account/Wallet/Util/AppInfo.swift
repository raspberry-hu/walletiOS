//
//  AppInfo.swift
//  MEGA
//
//  Created by raspberry on 2022/4/29.
//  Copyright © 2022 MEGA. All rights reserved.
//

import Foundation

open class AppInfo {
    /// Return the main application bundle. If this is called from an extension, the containing app bundle is returned.
    public static var applicationBundle: Bundle {
        let bundle = Bundle.main
        switch bundle.bundleURL.pathExtension {
        case "app":
            return bundle
        case "appex":
            // .../Client.app/PlugIns/SendTo.appex
            return Bundle(
                url: bundle.bundleURL.deletingLastPathComponent().deletingLastPathComponent())!
        default:
            fatalError(
                "Unable to get application Bundle (Bundle.main.bundlePath=\(bundle.bundlePath))")
        }
    }

    public static var displayName: String {
        applicationBundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }

    public static var appVersion: String {
        applicationBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    public static var appVersionReportedToNeeva: String {
        #if DEBUG
            appVersion + "-dev"
        #else
            appVersion
        #endif
    }

    public static var buildNumber: String {
        applicationBundle.object(forInfoDictionaryKey: String(kCFBundleVersionKey)) as! String
    }

    /// Return the shared container identifier (also known as the app group) to be used with for example background
    /// http requests. It is the base bundle identifier with a "group." prefix.
    public static var sharedContainerIdentifier: String {
        let bundleIdentifier = baseBundleIdentifier
        return "group." + bundleIdentifier
    }

    /// Return the keychain access group.
    public static func keychainAccessGroupWithPrefix(_ prefix: String) -> String {
        let bundleIdentifier = baseBundleIdentifier
        return prefix + "." + bundleIdentifier
    }

    /// Return the base bundle identifier.
    ///
    /// This function is smart enough to find out if it is being called from an extension or the main application. In
    /// case of the former, it will chop off the extension identifier from the bundle since that is a suffix not part
    /// of the *base* bundle identifier.
    public static var baseBundleIdentifier: String {
        let bundle = Bundle.main
        let packageType = bundle.object(forInfoDictionaryKey: "CFBundlePackageType") as! String
        let baseBundleIdentifier = bundle.bundleIdentifier!
        if packageType == "XPC!" {
            let components = baseBundleIdentifier.components(separatedBy: ".")
            return components[0..<components.count - 1].joined(separator: ".")
        }
        return baseBundleIdentifier
    }

    // The port for the internal webserver, tests can change this
    public static var webserverPort = 6571
}

