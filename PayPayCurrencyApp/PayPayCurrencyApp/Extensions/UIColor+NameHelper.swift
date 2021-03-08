//
//  UIColor+NameHelper.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 4/3/21.
//

import UIKit

extension UIColor {
    
    convenience init?(of name: ColorName) {
        self.init(named: name.rawValue)
    }
}

extension UIColor {
    
    enum ColorName: String {
        
        case primary            = "primaryColor"
        case shadow             = "shadowColor"
        
        case gradientStart      = "gradientStart"
        case gradientEnd        = "gradientEnd"
    }
}
