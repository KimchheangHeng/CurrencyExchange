//
//  HomeViewController.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 3/3/21.
//

import UIKit

protocol HomeViewControllerDelegate: class {
    func didSelectChangeCurrency(viewModel: CurrenciesListPresentable)
    func showErrorMessage(for error: Error)
}

class HomeViewController: BaseViewController {
    
    private var headerView: CurrencySourceHeaderView!
    private var headerViewMinHeight: CGFloat = 120
    private var headerViewMaxHeight: CGFloat = 160
    
    weak var delegate: HomeViewControllerDelegate?
    private var viewModel: CurrenciesListViewModel!
    
    convenience init(viewModel: CurrenciesListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MAKR: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        handleTableViewDidPullToRefresh(refreshControl)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Setup UI
    private func setupTableView() {
        ExchangeRateCell.registerNibCell(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        tableView.addGestureRecognizer(
            UITapGestureRecognizer(target: self,
                                   action: #selector(handleTableViewDidTap(_:)))
        )
        
        tableView.refreshControl?.addTarget(
            self, action: #selector(handleTableViewDidPullToRefresh(_:)), for: .valueChanged)
    }
    
    private func setupHeaderView() {
        let headerFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerViewMaxHeight)
        headerView = CurrencySourceHeaderView(frame: headerFrame)
        headerView.delegate = self
        updateHeaderView()
        
        view.addSubview(headerView)
        view.bringSubviewToFront(headerView)
        tableView.contentInset = UIEdgeInsets(top: headerViewMaxHeight + 8, left: 0, bottom: 8, right: 0)
    }
    
    private func updateHeaderView() {
        headerView.configView(with: viewModel.selectedCurrency, amount: viewModel.inputAmount)
        headerView.layoutSubviews()
    }
    
    private func updateData() {
        self.tableView.reloadData()
        self.updateHeaderView()
    }
    
    // MARK: - Action
    @objc
    func handleTableViewDidTap(_ gesture: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc
    func handleTableViewDidPullToRefresh(_ refreshControl: UIRefreshControl) {
        viewModel?.performRequestExchangeRates { [weak self] error in
            guard let `self` = self else { return }
            refreshControl.endRefreshing()
            
            if let error = error {
                self.delegate?.showErrorMessage(for: error)
            }
            
            self.updateData()
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allCurrenciesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExchangeRateCell = tableView.dequeueReusableCell(for: indexPath)
        
        let currency = viewModel.allCurrenciesList[indexPath.row]
        let selected = viewModel.selectedCurrency
        let amount = viewModel.inputAmount
        cell.configView(with: currency, currencySource: selected, amount: amount)
        
        return cell
    }
}

// MARK: - TableView ScrollViewDelegate
extension HomeViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = headerViewMaxHeight - (scrollView.contentOffset.y + headerViewMaxHeight)
        let height = min(max(y, headerViewMinHeight), headerViewMaxHeight)
        let newFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
        
        guard headerView != nil else { return }
        headerView.frame = newFrame
        headerView.layoutSubviews()
    }
}

// MARK: - CurrencySourceHeaderDelegate
extension HomeViewController: CurrencySourceHeaderDelegate {
    
    func selectCurrencyDidClick() {
        delegate?.didSelectChangeCurrency(viewModel: viewModel)
    }
    
    func amountTextFieldDidChange(_ amount: Double) {
        viewModel.inputAmount = amount
        tableView.reloadData()
    }
}

// MARK: - SelectCurrencyFlowDeletate
extension HomeViewController: SelectCurrencyFlowDeletate {
    
    func currencyDidSelect(_ currency: CurrencyViewModel) {
        viewModel.selectedCurrency = currency
        updateData()
    }
}
