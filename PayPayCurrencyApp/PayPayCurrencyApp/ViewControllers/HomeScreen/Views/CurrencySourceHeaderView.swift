//
//  CurrencySourceHeaderView.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 4/3/21.
//

import UIKit
import RxSwift
import RxCocoa

class CurrencySourceHeaderView: View {
    
    @IBOutlet weak var backgroundGradient: View!
    
    @IBOutlet weak var shadowedView: View!
    @IBOutlet weak var currencyContainerView: UIView!
    @IBOutlet weak var currecnyFlagImageView: UIImageView!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    private var defaultTextFieldValue = "1.00"
    private let disposeBag = DisposeBag()
    
    var inputAmount = BehaviorRelay<Double>(value: 1.0)
    var selectedCurrency = BehaviorRelay<CurrencyViewModel>(
        value: CurrencyViewModel(code: "USD", name: "United State Dollar")
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundGradient.startColor = UIColor(of: .gradientStart)!
        self.backgroundGradient.endColor = UIColor(of: .gradientEnd)!
        self.backgroundGradient.isVerticalGradient = true
        self.shadowedView.setShadowBorder(color: UIColor(of: .shadow))
    }
    
    // MARK: - Setup UI
    private func setupView() {
        amountTextField.rx.text
            .asDriver()
            .drive(onNext: { [unowned self] amountText in
                self.inputAmount.accept(Double(amountText ?? defaultTextFieldValue) ?? 1.0)
            })
            .disposed(by: disposeBag)
        
        // To take only the first value to show on textField
        inputAmount.element(at: 0)
            .map({ $0.decimalFormatted })
            .subscribe(amountTextField.rx.text)
            .disposed(by: disposeBag)
        
        amountTextField.rx.controlEvent([.editingDidEnd])
            .asDriver()
            .drive(onNext: { [unowned self] in
                let inputText = self.amountTextField.text ?? ""
                if inputText == "" {
                    self.amountTextField.text = self.defaultTextFieldValue
                }
                
                // This is optinoal, but just to make it look nice formatted when user end editing
                if let amount = Double(inputText) {
                    self.amountTextField.text = amount.decimalFormatted
                }
            })
            .disposed(by: disposeBag)
        
        selectedCurrency.asDriver()
            .drive(onNext: { [unowned self] currency in
                currecnyFlagImageView.image = currency.flagImage
            })
            .disposed(by: disposeBag)
    }
}
