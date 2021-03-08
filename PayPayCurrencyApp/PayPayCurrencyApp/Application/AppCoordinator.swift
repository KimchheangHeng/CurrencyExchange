//
//  AppCoordinator.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 3/3/21.
//

import UIKit
import Swinject

class AppCoordinator: CoordinatorType {
    
    let window: UIWindow
    let container: Container
    
    var homeCoordinator: HomeCoordinator!
    
    func start() {
        
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        homeCoordinator = HomeCoordinator(container: container, navigationController: navigationController)
        coordinate(to: homeCoordinator)
    }
    
    init(window: UIWindow) {
        self.window = window
        self.container = Container()
        setupDependencies()
    }
}

extension AppCoordinator {
    
    func setupDependencies() {
        container.register(NetworkManagerType.self) { _ in NetworkManager() }
        container.register(SavableType.self) { _ in UserDefaultManager() }
        
        container.register(DataManagerType.self) { r in
            let userDefaultManager = r.resolve(SavableType.self)!
            let networkManager = r.resolve(NetworkManagerType.self)!
            return DataManager(networkManager: networkManager,
                               userDefaultManager: userDefaultManager)
        }
        
        container.register(CurrenciesListViewModel.self) { _ -> CurrenciesListViewModel in
            return CurrenciesListViewModel(with: self.container)
        }
        
        container.register(HomeViewController.self) { (r) -> HomeViewController in
            let viewModel = r.resolve(CurrenciesListViewModel.self) ?? CurrenciesListViewModel(with: self.container)
            let viewController = HomeViewController(viewModel: viewModel)
            return viewController
        }
    }
}
