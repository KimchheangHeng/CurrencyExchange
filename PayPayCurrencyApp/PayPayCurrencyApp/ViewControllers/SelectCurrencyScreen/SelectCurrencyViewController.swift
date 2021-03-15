//
//  SelectCurrencyViewController.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 6/3/21.
//

import UIKit
import RxSwift
import RxCocoa

class SelectCurrencyViewController: BaseViewController {
    
    var viewModel: CurrenciesListViewModel!
    var coordinator: SelectCurrencyCoordinator!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        bindViewModel()
    }
    
    // MARK: - Setup UI
    private func setupTableView() {
        CurrencyCell.registerNibCell(tableView)
        
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                self.coordinator.dismiss()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        // MARK: - Inputs
        let selectedCurrencies = tableView.rx.itemSelected
            .map({ [unowned self] indexPath in
                return self.viewModel.allCurrenciesList[indexPath.row]
            })
            .asDriver(onErrorJustReturn: viewModel.selectedCurrency)
        
        let input = CurrenciesListViewModel.Input(selectedCurrencies: selectedCurrencies)
        
        // MARK: Outputs
        _ = viewModel.transform(input: input)
        
        selectedCurrencies.drive(onNext: { [unowned self] _ in
            self.coordinator.dismiss()
        }).disposed(by: disposeBag)
        
    }
}

// MARK: - UITableViewDataSource
extension SelectCurrencyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allCurrenciesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyCell = tableView.dequeueReusableCell(for: indexPath)
        let currency = viewModel.allCurrenciesList[indexPath.row]
        cell.configView(with: currency)
        return cell
    }
}
