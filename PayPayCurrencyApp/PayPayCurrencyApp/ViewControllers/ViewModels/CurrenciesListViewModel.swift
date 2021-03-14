//
//  CurrenciesListViewModel.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 3/3/21.
//

import Swinject

protocol CurrenciesListPresentable: class {
    var inputAmount: Double { set get }
    var allCurrenciesList: [CurrencyViewModel] { get }
    
    var selectedCurrency: CurrencyViewModel { get set }
    var selectedCurrencyIndex: IndexPath? { get }
}

class CurrenciesListViewModel: CurrenciesListPresentable {
    
    private let container: Container
    private let dataManager: DataManagerType!
    
    private var currenciesList: [CurrencyViewModel] = []
    
    init(with dependencies: Container) {
        container = dependencies
        dataManager = dependencies.resolve(DataManagerType.self)
    }
    
    func performRequestExchangeRates(completedWithError: @escaping (Error?) -> Void) {
        
        dataManager.fetchCurrenciesList { [weak self] currenciesList, error in
            guard let `self` = self else { return }
            
            if let error = error {
                completedWithError(error)
                return
            }
            
            self.currenciesList = currenciesList?.currencies.map {
                CurrencyViewModel(code: $0, name: $1)
            } ?? []
        
            self.dataManager.fetchCurrenciesExchangeRates { exchangeRates, error  in
                if let error = error {
                    completedWithError(error)
                    return
                }
                
                self.currenciesList = self.currenciesList.map({ currency -> CurrencyViewModel in
                    var newCurrency = currency
                    let rate = exchangeRates?.usdCompareRates[currency.displayCode]
                    newCurrency.updateExchangeRate(rate)
                    return newCurrency
                })
                
                completedWithError(nil)
            }
        }
    }

    // MARK: - CurrenciesListPresentable
    var inputAmount: Double = 1
    
    var selectedCurrency: CurrencyViewModel = CurrencyViewModel(code: "USD", name: "United State Dollar")
    
    var allCurrenciesList: [CurrencyViewModel] {
        return currenciesList.sorted(by: { $0.displayCode < $1.displayCode })
    }
    
    var selectedCurrencyIndex: IndexPath? {
        guard let row = allCurrenciesList.firstIndex(where: {
            $0.displayCode == selectedCurrency.displayCode }) else { return nil }
        
        return IndexPath(row: row, section: 0)
    }
}
