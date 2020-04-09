//
//  StringExtension.swift
//  ClassBot
//
//  Created by Nathan FALLET on 05/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

extension String {

    // Localization

    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }

    func format(_ args : CVarArg...) -> String {
        return String(format: self, locale: .current, arguments: args)
    }

    func format(_ args : [String]) -> String {
        return String(format: self, locale: .current, arguments: args)
    }
    
    // Date
    
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Europe/Paris")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: self)
    }
    
    // Convert to configuration
    func toAPIConfiguration() -> APIConfiguration {
        var workspace = self
        
        // Get protocol
        var proto: String
        if workspace.starts(with: "http://") {
            // Set https
            proto = "http"
            workspace = String(workspace.suffix(workspace.count - 7))
        } else if workspace.starts(with: "https://") {
            // Set http
            proto = "https"
            workspace = String(workspace.suffix(workspace.count - 8))
        } else {
            // Set https by default
            proto = "https"
        }
        
        // Remove / at end if exists
        if workspace.hasSuffix("/") {
            // Remove it
            workspace = String(workspace.prefix(workspace.count - 1))
        }
        
        // Get port
        var port: Int
        let parts = workspace.split(separator: ":")
        if parts.count == 2, let integer = Int(parts[1]) {
            // Set port
            port = integer
        } else {
            // Set port based on protocol
            port = proto == "https" ? 443 : 80
        }
        
        // Get host
        var host = workspace
        if parts.count > 0 {
            host = String(parts[0])
        }
        
        // Build configuration
        return APIConfiguration(proto: proto, host: host, port: port, classes: [])
    }

}
