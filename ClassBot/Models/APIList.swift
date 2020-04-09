//
//  APIList.swift
//  ClassBot
//
//  Created by Nathan FALLET on 04/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

struct APIList: Codable {
    
    var classes: [Classe]?
    var cours: [Cours]?
    var devoirs: [Devoirs]?
    
}
