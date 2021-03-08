//
//  CurrenciesListTest.swift
//  PayPayCurrencyAppTests
//
//  Created by Kimchheang on 8/3/21.
//

import XCTest
@testable import PayPayCurrencyApp

class CurrenciesListTest: XCTestCase {

    func testJsonDecoding() {
        do {
            if let path = Bundle(for: type(of: self)).path(forResource: "CurrenciesList", ofType: "json") {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                let _ = try jsonDecoder.decode(CurrenciesList.self, from: data)
            } else {
                fatalError("No file found!")
            }
        } catch {
            XCTFail()
        }
    }
}
