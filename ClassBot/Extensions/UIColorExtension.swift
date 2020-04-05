//
//  UIColorExtension.swift
//  ClassBot
//
//  Created by Nathan FALLET on 05/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var background: UIColor {
        if #available(iOS 13, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
    
}
