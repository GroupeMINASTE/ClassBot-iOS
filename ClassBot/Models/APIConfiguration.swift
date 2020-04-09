//
//  APIConfiguration.swift
//  ClassBot
//
//  Created by Nathan FALLET on 08/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

struct APIConfiguration: Codable {
    
    var proto: String
    var host: String
    var port: Int
    var classes: [Int]
    
    func toString() -> String {
        return "\(proto)://\(host):\(port)"
    }
    
}
