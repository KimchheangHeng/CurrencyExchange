//
//  SelectCurrencyCoordinator.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 6/3/21.
//

import UIKit

class SelectCurrencyCoordinator: CoordinatorType {
    
    let navigationController: UINavigationController
    let viewModel: CurrenciesListViewModel!
    
    func start() {
        let viewController = SelectCurrencyViewController()
        viewController.viewModel = viewModel
        viewController.coordinator = self
        
        let navigationVC = UINavigationController(rootViewController: viewController)
        navigationController.present(navigationVC, animated: true, completion: { })
    }
    
    init(navigationController: UINavigationController, viewModel: CurrenciesListViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true, completion: { })
    }
}
