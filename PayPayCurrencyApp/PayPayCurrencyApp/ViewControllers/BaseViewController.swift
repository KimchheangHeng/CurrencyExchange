//
//  BaseViewController.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 7/3/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        return refreshControl
    }()
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        view.backgroundColor = UIColor.systemBackground
        tableView = UITableView(frame: view.frame)
        tableView.setupTableView()
        
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        tableView.insetsContentViewsToSafeArea = false
        tableView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.setConstraintToSuperView()
    }
}
