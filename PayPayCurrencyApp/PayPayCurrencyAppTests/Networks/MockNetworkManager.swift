//
//  MockNetworkManager.swift
//  PayPayCurrencyAppTests
//
//  Created by Kimchheang on 8/3/21.
//

import XCTest
@testable import PayPayCurrencyApp

class MockNetworkManager: NetworkManagerType {
    
    // MARK: - NetworkManagerType
    func fetchCurrenciesExchangeRates(completion: @escaping Response<ExchangeRates>) {
        completion(ExchangeRates.dummyData, nil)
    }
    
    func fetchCurrenciesList(completion: @escaping Response<CurrenciesList>) {
        completion(CurrenciesList.dummyData, nil)
    }
}

extension ExchangeRates {
    static var dummyData: ExchangeRates? {
        guard let path = Bundle.main.path(forResource: "CurrenciesLive", ofType: "json") else {
            return nil
        }
            
        let fileUrl = URL(fileURLWithPath: path)
        let data = (try? Data(contentsOf: fileUrl, options: .mappedIfSafe)) ?? Data()
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return try? jsonDecoder.decode(ExchangeRates.self, from: data)
    }
}


extension CurrenciesList {
    static var dummyData: CurrenciesList? {
        guard let path = Bundle.main.path(forResource: "CurrenciesList", ofType: "json") else {
            return nil
        }
        
        let fileUrl = URL(fileURLWithPath: path)
        let data = (try? Data(contentsOf: fileUrl, options: .mappedIfSafe)) ?? Data()
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return  try? jsonDecoder.decode(CurrenciesList.self, from: data)
    }
}
