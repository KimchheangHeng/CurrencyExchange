//
//  ExchangeRates.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 4/3/21.
//

import Foundation

struct ExchangeRates: Codable {
    private let success: Bool
    private let terms: String
    private let privacy: String
    private let timestamp: Double
    private let source: String
    private let quotes: [String: Double]
}

extension ExchangeRates {
    
    var usdCompareRates: [String: Double] {
        var newDict = [String: Double]()
        quotes.keys.forEach({
            newDict[String($0.suffix(3))] = quotes[$0]
        })
        
        return newDict
    }
}
