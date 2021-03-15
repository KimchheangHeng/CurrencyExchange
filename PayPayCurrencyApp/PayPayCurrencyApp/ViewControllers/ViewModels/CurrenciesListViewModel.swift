//
//  CurrenciesListViewModel.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 3/3/21.
//

import Swinject
import RxSwift
import RxCocoa

protocol CurrenciesListViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

protocol CurrenciesListPresentable: class {
    var allCurrenciesList: [CurrencyViewModel] { get }
    var selectedCurrency: CurrencyViewModel { get }
    var selectedCurrencyIndex: IndexPath? { get }
}

class CurrenciesListViewModel: CurrenciesListViewModelType {
    
    private let container: Container
    private let dataManager: DataManagerType!
    
    private var _isLoading = BehaviorRelay<Bool>(value: false)
    private var _currenciesList = BehaviorRelay<[CurrencyViewModel]>(value: [])
    private var _error = BehaviorRelay<Error?>(value: nil)
    
    private var _inputAmount = BehaviorRelay<Double>(value: 1)
    private var _selectedCurrency = BehaviorRelay<CurrencyViewModel>(
        value: CurrencyViewModel(code: "USD", name: "United State Dollar")
    )
    
    let disposeBag = DisposeBag()
    
    init(with dependencies: Container) {
        container = dependencies
        dataManager = dependencies.resolve(DataManagerType.self)
    }
    
    // MARK: - Input
    struct Input {
        var inputAmount: Driver<Double>?
        var selectedCurrencies: Driver<CurrencyViewModel>?
        var fetchCurrenciesTrigger: Driver<Void>?
        
        init(inputAmount: Driver<Double>? = nil,
             selectedCurrencies: Driver<CurrencyViewModel>? = nil,
             fetchCurrenciesTrigger: Driver<Void>? = nil) {
            
            self.inputAmount = inputAmount
            self.selectedCurrencies = selectedCurrencies
            self.fetchCurrenciesTrigger = fetchCurrenciesTrigger
        }
    }
    
    // MARK: - Output
    struct Output {
        let sourceAmount: Driver<Double>
        let sourceCurrency: Driver<CurrencyViewModel>
        
        let isLoading: Driver<Bool>
        let currenciesList: Driver<[CurrencyViewModel]>
        let error: Driver<Error?>
    }
    
    func transform(input: Input) -> Output {
        // Triggered when user pull down to refresh.
        if input.fetchCurrenciesTrigger != nil {
            input.fetchCurrenciesTrigger?
                .asObservable()
                .subscribe(onNext: { [unowned self] in
                    self.performRequestExchangeRates()
                })
                .disposed(by: disposeBag)
        }
        
        // Triggered when user input value to amount textField
        if input.inputAmount != nil {
            input.inputAmount?
                .asObservable()
                .bind(to: _inputAmount)
                .disposed(by: disposeBag)
        }
        
        // Triggered when user select on currency
        if input.selectedCurrencies != nil {
            input.selectedCurrencies?
                .asObservable()
                .bind(to: _selectedCurrency)
                .disposed(by: disposeBag)
        }
        
        let sourceAmount = _inputAmount
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: _inputAmount.value)
        
        let sourceCurrency = _selectedCurrency
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: _selectedCurrency.value)
        
        return Output(sourceAmount: sourceAmount,
                      sourceCurrency: sourceCurrency,
                      isLoading: _isLoading.asDriver(),
                      currenciesList: _currenciesList.asDriver(),
                      error: _error.asDriver())
    }
    
    func loadInitialData() {
        performRequestExchangeRates()
    }
    
    private func performRequestExchangeRates() {
        _isLoading.accept(true)
        _currenciesList.accept([])
        _error.accept(nil)
        
        var tempCurrenciesList = [CurrencyViewModel]()
        
        self.dataManager.fetchCurrenciesList { [weak self] currenciesList, error in
            guard let `self` = self else { return }
            
            self._isLoading.accept(error == nil)
            self._currenciesList.accept([])
            self._error.accept(error)
            
            tempCurrenciesList = currenciesList?.currencies.map {
                CurrencyViewModel(code: $0, name: $1)
            } ?? []
            
            self.dataManager.fetchCurrenciesExchangeRates { exchangeRates, error  in
                self._isLoading.accept(false)
                self._error.accept(error)
                
                tempCurrenciesList = tempCurrenciesList.map({ currency -> CurrencyViewModel in
                    var newCurrency = currency
                    let rate = exchangeRates?.usdCompareRates[currency.displayCode]
                    newCurrency.updateExchangeRate(rate)
                    return newCurrency
                })
                
                self._currenciesList.accept(tempCurrenciesList)
            }
        }
    }
}

// MARK: - CurrenciesListPresentable
extension CurrenciesListViewModel: CurrenciesListPresentable {
    var allCurrenciesList: [CurrencyViewModel] {
        return _currenciesList.value.sorted(by: { $0.displayCode < $1.displayCode })
    }
    
    var selectedCurrency: CurrencyViewModel {
        return _selectedCurrency.value
    }
    
    var selectedCurrencyIndex: IndexPath? {
        guard let row = allCurrenciesList.firstIndex(where: {
            $0.displayCode == selectedCurrency.displayCode }) else { return nil }
        
        return IndexPath(row: row, section: 0)
    }
}
