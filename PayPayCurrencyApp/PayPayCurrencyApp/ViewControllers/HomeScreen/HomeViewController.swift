//
//  HomeViewController.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 3/3/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeViewControllerDelegate: class {
    func didSelectChangeCurrency(viewModel: CurrenciesListViewModel)
    func showErrorMessage(for error: Error)
}

class HomeViewController: BaseViewController {
    
    private var headerView: CurrencySourceHeaderView!
    private var headerViewMinHeight: CGFloat = 120
    private var headerViewMaxHeight: CGFloat = 160
    
    weak var delegate: HomeViewControllerDelegate?
    private var viewModel: CurrenciesListViewModel!
    
    private let disposeBag = DisposeBag()
    
    convenience init(viewModel: CurrenciesListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MAKR: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeaderView()
        bindViewModel()
        viewModel.loadInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.bind(onNext: { [unowned self] recognizer in
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        tableView.addGestureRecognizer(tapGesture)
    }
    
    private func setupHeaderView() {
        let headerFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerViewMaxHeight)
        headerView = CurrencySourceHeaderView(frame: headerFrame)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.delegate?.didSelectChangeCurrency(viewModel: viewModel)
            })
            .disposed(by: disposeBag)
        headerView.currencyContainerView.addGestureRecognizer(tapGesture)
        
        view.addSubview(headerView)
        view.bringSubviewToFront(headerView)
        tableView.contentInset = UIEdgeInsets(top: headerViewMaxHeight + 8, left: 0, bottom: 8, right: 0)
    }
    
    private func bindViewModel() {
        // MARK: - Inputs
        let fetchCurrenciesTrigger = refreshControl.rx.controlEvent(UIControl.Event.valueChanged).asDriver()
        let inputAmount = headerView.inputAmount.asDriver()
        let input = CurrenciesListViewModel.Input(inputAmount: inputAmount, fetchCurrenciesTrigger: fetchCurrenciesTrigger)
        
        // MARK: Outputs
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        // Amount
        output.sourceAmount
            .drive(headerView.inputAmount)
            .disposed(by: disposeBag)
        
        output.sourceAmount
            .drive(onNext: { [unowned self] list in
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        // Currency
        output.sourceCurrency
            .drive(headerView.selectedCurrency)
            .disposed(by: disposeBag)
        
        output.sourceCurrency
            .drive(onNext: { [unowned self] _ in
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        // Error message
        output.error.drive(onNext: { error in
            guard let error = error else { return }
            self.delegate?.showErrorMessage(for: error)
        }).disposed(by: disposeBag)
        
        // Currencies List
        output.currenciesList
            .drive(onNext: { [unowned self] _ in
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
        
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
        let amount = headerView.inputAmount.value
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
