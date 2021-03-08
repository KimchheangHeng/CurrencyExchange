//
//  SelectCurrencyViewController.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 6/3/21.
//

import UIKit

class SelectCurrencyViewController: BaseViewController {
    
    var viewModel: CurrenciesListPresentable!
    var coordinator: SelectCurrencyCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
    }
    
    // MARK: - Setup UI
    private func setupTableView() {
        CurrencyCell.registerNibCell(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = nil
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        tableView.contentInsetAdjustmentBehavior = .automatic
        
        if let indexPath = viewModel.selectedCurrencyIndex {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    
    private func setupNavigationBar() {
        title = "Select your currency"
        navigationController?.navigationBar.tintColor = UIColor(of: .primary)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonDidClick(_:))
        )
    }
    
    // MARK: - Actions
    @objc
    func cancelButtonDidClick(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: { })
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SelectCurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allCurrenciesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyCell = tableView.dequeueReusableCell(for: indexPath)
        let currency = viewModel.allCurrenciesList[indexPath.row]
        cell.configView(with: currency)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.dismiss(animated: true, completion: { })
        coordinator.selectCurrencyFlow?.currencyDidSelect(viewModel.allCurrenciesList[indexPath.row])
    }
}
