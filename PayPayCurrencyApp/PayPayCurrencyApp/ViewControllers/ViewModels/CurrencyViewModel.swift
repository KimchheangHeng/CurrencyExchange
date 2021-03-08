//
//  CurrencyViewModel.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 6/3/21.
//

import UIKit
import FlagKit

protocol CurrencyPresentable {
    var displayCode: String { get }
    var displayName: String { get }
    var flagImage: UIImage? { get }
    func getAmount(with rate: CurrencyViewModel, amount: Double) -> String
}

struct CurrencyViewModel: Equatable {
    private let currencyCode: String
    private let currencyName: String
    private var exchangeRate: Double?
    
    init(code: String, name: String, rate: Double? = 1) {
        currencyCode = code
        currencyName = name
        exchangeRate = rate
    }
    
    mutating func updateExchangeRate(_ rate: Double?) {
        self.exchangeRate = rate
    }
}

// MARK: - Display Properties
extension CurrencyViewModel: CurrencyPresentable {
    
    var displayCode: String {
        return self.currencyCode
    }
    
    var displayName: String {
        return self.currencyName
    }
    
    var flagImage: UIImage? {
        // example currency "KHR" -> country code "KH"
        let countryCode = String(currencyCode.prefix(2)).uppercased()
        return Flag(countryCode: countryCode)?.originalImage
    }
    
    func getAmount(with source: CurrencyViewModel, amount: Double) -> String {
        guard let sourceRate = source.exchangeRate, sourceRate > 0,
              let targetRate = self.exchangeRate, targetRate > 0 else { return "#.##" }
        
        let amountInUSD = amount / sourceRate
        let amountInTargetted = amountInUSD * targetRate
        return amountInTargetted.decimalFormatted
    }
}
