//
//  NetworkManager.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 4/3/21.
//

import Moya

typealias Response<T: Decodable> = ((_ object: T?, _ error: Error?) -> Void)

protocol NetworkManagerType {
    func fetchCurrenciesExchangeRates(completion: @escaping Response<ExchangeRates>)
    func fetchCurrenciesList(completion: @escaping Response<CurrenciesList>)
}

struct NetworkManager: NetworkManagerType {
    
    // MARK: - Routers
    let currencyExchangeRouter = Router<CurrencyExchangeAPI>()
    
    // MARK: - NetworkManagerType
    func fetchCurrenciesExchangeRates(completion: @escaping Response<ExchangeRates>) {
        currencyExchangeRouter.request(target: CurrencyExchangeAPI.currencyExchangeRates, completion: completion)
    }
    
    func fetchCurrenciesList(completion: @escaping Response<CurrenciesList>) {
        currencyExchangeRouter.request(target: CurrencyExchangeAPI.currenciesList, completion: completion)
    }
}

// MARK: - Network Error
 enum NetworkError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
 }
