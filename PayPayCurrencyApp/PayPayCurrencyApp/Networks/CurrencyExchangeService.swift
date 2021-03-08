//
//  CurrencyExchangeService.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 5/3/21.
//

import Moya

enum CurrencyExchangeAPI {
    case currenciesList
    case currencyExchangeRates
}

extension CurrencyExchangeAPI: TargetType {
    
    var baseURL: URL {
        URL(string: "http://api.currencylayer.com/")!
    }
    
    var path: String {
        self == .currenciesList ? "list" : "live"
    }
    
    var headers: [String : String]? { nil }
    
    var method: Method { .get }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        let parameters = [
            "access_key": "82fd56ee7b48acb7311cf1643f7f919a"
        ]
        
        return .requestParameters(
            parameters: parameters,
            encoding: URLEncoding.queryString
        )
    }
}
