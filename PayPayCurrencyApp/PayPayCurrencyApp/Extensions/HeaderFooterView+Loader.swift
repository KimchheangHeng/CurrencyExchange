//
//  HeaderFooterView+Loader.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 3/3/21.
//

import UIKit

extension UITableViewHeaderFooterView {
    
    class func reuseIdentifier() -> String {
        return "\(self)"
    }
    
    class func nib() -> UINib {
        return UINib(nibName: reuseIdentifier(), bundle: nil)
    }
    
    class func registerNib(_ tableView: UITableView) {
        tableView.register(nib(), forHeaderFooterViewReuseIdentifier: reuseIdentifier())
    }
    
    class func registerNib(_ tableView: UITableView, reuseIdentifier: String) {
        tableView.register(nib(), forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    class func registerClass(_ tableView: UITableView) {
        tableView.register(self, forHeaderFooterViewReuseIdentifier: reuseIdentifier())
    }
    
    class func registerClass(_ tableView: UITableView, reuseIdentifier: String) {
        tableView.register(self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    func setupHeaderView(headerTitle: String?) {
        textLabel?.text = headerTitle ?? ""
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        textLabel?.textAlignment = .natural
    }
}
