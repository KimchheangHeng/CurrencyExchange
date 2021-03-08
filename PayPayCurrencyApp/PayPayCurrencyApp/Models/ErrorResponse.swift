//
//  ErrorResponse.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 7/3/21.
//

import Foundation

struct ErrorResponse: Codable {
    let success: Bool
    let error: ErrorObject
}

struct ErrorObject: Codable {
    let code: Int
    let type: String
    let info: String
}
