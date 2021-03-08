//
//  HomeCoordinator.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 3/3/21.
//

import UIKit
import Swinject

class HomeCoordinator: CoordinatorType {
    
    let container: Container
    let navigationController: UINavigationController
    var homeViewController: HomeViewController!
    
    var selectCurrencyCoordinator: SelectCurrencyCoordinator!
    
    func start() {
        guard let viewController = container.resolve(HomeViewController.self) else { return }
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
        homeViewController = viewController
    }
    
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
    
    deinit {
        print("Deinit Home Coordinator")
    }
}

// MARK: - HomeViewControllerDelegate
extension HomeCoordinator: HomeViewControllerDelegate {
    
    func didSelectChangeCurrency(viewModel: CurrenciesListPresentable) {
        selectCurrencyCoordinator = SelectCurrencyCoordinator(navigationController: navigationController,
                                                              viewModel: viewModel)
        selectCurrencyCoordinator.selectCurrencyFlow = homeViewController
        coordinate(to: selectCurrencyCoordinator)
    }
    
    func showErrorMessage(for error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in }))
        navigationController.present(alertController, animated: true, completion: { })
    }
}

