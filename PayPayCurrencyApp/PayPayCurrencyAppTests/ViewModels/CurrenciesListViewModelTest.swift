//
//  CurrenciesListViewModelTest.swift
//  PayPayCurrencyAppTests
//
//  Created by Kimchheang on 8/3/21.
//

import Quick
import Nimble
import RxSwift
import RxCocoa
import Swinject
@testable import PayPayCurrencyApp

class CurrenciesListViewModelTest: QuickSpec {
    
    override func spec() {
        var container: Container!
        let disposeBag = DisposeBag()
        
        beforeEach {
            container = Container()
            container.register(NetworkManagerType.self) { _ in MockNetworkManager() }
            container.register(SavableType.self) { _ in MockDataManager() }
            
            container.register(DataManagerType.self) { r in
                let userDefaultManager = r.resolve(SavableType.self)!
                let networkManager = r.resolve(NetworkManagerType.self)!
                return DataManager(networkManager: networkManager,
                                   userDefaultManager: userDefaultManager)
            }
            
            container.register(CurrenciesListViewModel.self) { _ -> CurrenciesListViewModel in
                return CurrenciesListViewModel(with: container)
            }
        }
        
        it("starts fetching currency exchange rates") {
            let viewModel = container.resolve(CurrenciesListViewModel.self)
            viewModel?.loadInitialData()
            
            let input = CurrenciesListViewModel.Input()
            
            // MARK: Outputs
            let output = viewModel?.transform(input: input)
            
            // Error message
            output?.error.drive(onNext: { error in
                expect(error).to(beNil())
            }).disposed(by: disposeBag)
        }
    }
}
