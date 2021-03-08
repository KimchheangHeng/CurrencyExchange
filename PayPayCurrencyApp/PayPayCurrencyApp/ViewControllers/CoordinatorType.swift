//
//  CoordinatorType.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 3/3/21.
//

import Foundation

protocol CoordinatorType {
    func start()
    func coordinate(to coordinator: CoordinatorType)
}

extension CoordinatorType {
    
    func coordinate(to coordinator: CoordinatorType) {
        coordinator.start()
    }
}
