//
//  TableView+ReusableCell.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 3/3/21.
//

import UIKit

extension UITableView {
    
    func setupTableView() {
        rowHeight = UITableView.automaticDimension
        separatorStyle = .none
        estimatedRowHeight = 100
        
        backgroundColor = UIColor.systemBackground
        tableFooterView = UIView()
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with identifier: String = T.reuseIdentifier(), for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else { return T() }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(with identifier: String = T.reuseIdentifier()) -> T {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else { return T() }
        return headerFooterView
    }
}
