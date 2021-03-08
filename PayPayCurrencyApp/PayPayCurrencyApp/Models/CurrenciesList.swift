//
//  CurrenciesList.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 4/3/21.
//

import Foundation

struct CurrenciesList: Codable {
    let success: Bool
    let terms: String
    let privacy: String
    let currencies: [String: String]
}
