//
//  CurrencyViewModelTest.swift
//  PayPayCurrencyAppTests
//
//  Created by Kimchheang on 8/3/21.
//

import Quick
import Nimble
@testable import PayPayCurrencyApp

class CurrencyViewModelTest: QuickSpec {
    
    override func spec() {
        
        let jpy = CurrencyViewModel(code: "JPY", name: "Japanese Yen", rate: 108.41)
        let krw = CurrencyViewModel(code: "KRW", name: "Korean Won", rate: 1131.11)
        let khr = CurrencyViewModel(code: "KHR", name: "Cambodian Riel", rate: 4071.41)
        let myr = CurrencyViewModel(code: "MYR", name: "Malaysian Ringgit", rate: 4.07)
        let usd = CurrencyViewModel(code: "USD", name: "United State Dollar", rate: 1.0)
        
        it("checks if the update exchange rate work properly") {
            var japaneseCurrency = CurrencyViewModel(code: "JPY", name: "Japanese Yen")
            japaneseCurrency.updateExchangeRate(108.41)
            expect(japaneseCurrency).to(equal(jpy))
        }
        
        it("checks if the string is return as expected for negative rate") {
            var koreanCurrency = krw
            koreanCurrency.updateExchangeRate(-1)
            
            let amountFromKRW = koreanCurrency.getAmount(with: khr, amount: 1000)
            expect(amountFromKRW).to(equal("#.##"), description: "the false back of funcition is #.##")
        }
        
        it("checks if the string is return as expected for zero rate") {
            var malaysianCurrency = myr
            malaysianCurrency.updateExchangeRate(0)
            
            let amountFromMYR = malaysianCurrency.getAmount(with: khr, amount: 1000)
            expect(amountFromMYR).to(equal("#.##"), description: "the false back of funcition is #.##")
        }
        
        it("checks if the string is return as expected for null rate") {
            var malaysianCurrency = myr
            malaysianCurrency.updateExchangeRate(nil)
            
            let amountFromMYR = malaysianCurrency.getAmount(with: khr, amount: 1000)
            expect(amountFromMYR).to(equal("#.##"), description: "the false back of funcition is #.##")
        }
        
        it("checks if the rate calcultion is correct for cross country conversion") {
            let usdAmount = 500.0
            let amountInJPY = Double(jpy.getAmount(with: usd, amount: usdAmount)) ?? 0
            let amountInKHR = Double(khr.getAmount(with: usd, amount: usdAmount)) ?? 0
            let amountInKHRFromJPY = Double(jpy.getAmount(with: khr, amount: amountInJPY))
            
            expect(amountInKHR).to(equal(amountInKHRFromJPY))
        }
    }
}

// MARK: - Dummy data
extension CurrencyViewModelTest {
}
