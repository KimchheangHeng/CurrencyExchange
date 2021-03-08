//
//  DoubleExtension.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 7/3/21.
//

import Foundation

extension Double {
    
    var decimalFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "#.##"
    }
}
