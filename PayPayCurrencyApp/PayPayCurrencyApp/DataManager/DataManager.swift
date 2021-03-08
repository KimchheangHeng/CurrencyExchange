//
//  DataManager.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 6/3/21.
//

import Foundation

protocol DataManagerType {
    func fetchCurrenciesExchangeRates(completion: @escaping Response<ExchangeRates>)
    func fetchCurrenciesList(completion: @escaping Response<CurrenciesList>)
}

struct DataManager: DataManagerType {
    
    private var networkManager: NetworkManagerType!
    private var userDefaultManager: SavableType!
    
    init(networkManager: NetworkManagerType, userDefaultManager: SavableType) {
        self.networkManager = networkManager
        self.userDefaultManager = userDefaultManager
    }
    
    // MARK: - DataManagerType
    func fetchCurrenciesExchangeRates(completion: @escaping Response<ExchangeRates>) {
        do {
            // Fetch from local first to check if it was requested less than 30mn ago
            let rates = try userDefaultManager.getObject(
                forKey: "\(ExchangeRates.self)", castTo: ExchangeRates.self
            )
            
            // If the last updated time has reached 30mn
            guard userDefaultManager.shouldRefreshDataAfter30Minute else {
                completion(rates, nil)
                return
            }
            
            // Request API
            fetchNewCurrencyRatesAPI(completion: completion)
            
        } catch (let error) {
            // In case, it's an error of no value, do the api call here.
            guard (error as! SavableError) == SavableError.noValue else {
                completion(nil, error)
                return
            }
            
            // Request API
            fetchNewCurrencyRatesAPI(completion: completion)
        }
    }
    
    func fetchCurrenciesList(completion: @escaping Response<CurrenciesList>) {
        do {
            // Fetch from local first to check if it was requested
            let currencies = try userDefaultManager.getObject(
                forKey: "\(CurrenciesList.self)", castTo: CurrenciesList.self
            )
            
            completion(currencies, nil)
            
        } catch (let error) {
            // In case, it's an error of no value, do the api call here.
            guard (error as! SavableError) == SavableError.noValue else {
                completion(nil, error)
                return
            }
            
            // Request API
            fetchCurrenciesListAPI(completion: completion)
        }
    }
    
    private func fetchNewCurrencyRatesAPI(completion: @escaping Response<ExchangeRates>) {
        networkManager.fetchCurrenciesExchangeRates { exchangeRate, error in
            
            guard let rate = exchangeRate else {
                completion(exchangeRate, error)
                return
            }
            
            do {
                try userDefaultManager.setObject(rate, forKey: "\(ExchangeRates.self)")
                userDefaultManager.lastUpdatedTime = Date()
                completion(rate, error)
            } catch (let dataError) {
                completion(rate, dataError)
            }
        }
    }
    
    private func fetchCurrenciesListAPI(completion: @escaping Response<CurrenciesList>) {
        networkManager.fetchCurrenciesList { currenciesList, error in
            
            guard let currencies = currenciesList else {
                completion(currenciesList, error)
                return
            }
            
            do {
                try userDefaultManager.setObject(currencies, forKey: "\(CurrenciesList.self)")
                completion(currencies, error)
            } catch (let dataError) {
                completion(currencies, dataError)
            }
        }
    }
}
