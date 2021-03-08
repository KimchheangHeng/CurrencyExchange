//
//  CurrencySourceHeaderView.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 4/3/21.
//

import UIKit

protocol CurrencySourceHeaderDelegate: class {
    func selectCurrencyDidClick()
    func amountTextFieldDidChange(_ amount: Double)
}

class CurrencySourceHeaderView: View {
    
    @IBOutlet weak var backgroundGradient: View!
    
    @IBOutlet weak var shadowedView: View!
    @IBOutlet weak var currencyContainerView: UIView!
    @IBOutlet weak var currecnyFlagImageView: UIImageView!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    weak var delegate: CurrencySourceHeaderDelegate?
    private var defaultTextFieldValue = "1.00"
    
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
        currencyContainerView.addGestureRecognizer(
            UITapGestureRecognizer(target: self,
                                   action: #selector(changeCurrencyDidTap(_:)))
        )
        
        amountTextField.delegate = self
        amountTextField.text = defaultTextFieldValue
    }
    
    func configView(with viewModel: CurrencyViewModel, amount: Double) {
        currecnyFlagImageView.image = viewModel.flagImage
        amountTextField.text = amount.decimalFormatted
    }
    
    // MARK: - Actions
    @objc
    func changeCurrencyDidTap(_ gesture: UIGestureRecognizer) {
        delegate?.selectCurrencyDidClick()
    }
    
    @IBAction
    func amountTextFiedValueChanged(_ textField: UITextField) {
        let amountText = amountTextField.text ?? defaultTextFieldValue
        guard let amount = Double(amountText) else { return }
        delegate?.amountTextFieldDidChange(amount)
    }
}

// MARK: - UITextFieldDelegate
extension CurrencySourceHeaderView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let inputText = textField.text ?? ""
        if inputText == "" {
            textField.text = defaultTextFieldValue
            guard let amount = Double(defaultTextFieldValue) else { return }
            delegate?.amountTextFieldDidChange(amount)
        }
        
        // This is optinoal, but just to make it look nice formatted when user end editing
        if let amount = Double(textField.text ?? defaultTextFieldValue) {
            textField.text = amount.decimalFormatted
        }
        
    }
}
