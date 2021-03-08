//
//  SelectCurrencyCoordinator.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 6/3/21.
//

import UIKit

protocol SelectCurrencyFlowDeletate: class {
    func currencyDidSelect(_ currency: CurrencyViewModel)
}

class SelectCurrencyCoordinator: CoordinatorType {
    
    let navigationController: UINavigationController
    let viewModel: CurrenciesListPresentable!
    weak var selectCurrencyFlow: SelectCurrencyFlowDeletate?
    
    func start() {
        let viewController = SelectCurrencyViewController()
        viewController.viewModel = viewModel
        viewController.coordinator = self
        
        let navigationVC = UINavigationController(rootViewController: viewController)
        navigationController.present(navigationVC, animated: true, completion: { })
    }
    
    init(navigationController: UINavigationController, viewModel: CurrenciesListPresentable) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
}
