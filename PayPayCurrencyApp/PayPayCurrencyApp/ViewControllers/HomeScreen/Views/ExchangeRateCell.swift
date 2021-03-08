//
//  ExchangeRateCell.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 4/3/21.
//

import UIKit

class ExchangeRateCell: UITableViewCell {
    
    @IBOutlet weak var roundedCornerView: View!
    @IBOutlet weak var shadowedView: View!
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyAmountLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowedView.setShadowBorder(color: UIColor(of: .shadow))
    }
    
    // MARK: - Setup UI
    func configView(with viewModel: CurrencyViewModel, currencySource: CurrencyViewModel, amount: Double) {
        currencyCodeLabel.text = viewModel.displayCode
        currencyNameLabel.text = viewModel.displayName
        flagImageView.image = viewModel.flagImage
        currencyAmountLabel.text = viewModel.getAmount(with: currencySource, amount: amount)
        
        shadowedView.setShadowBorder(color: UIColor(of: .shadow))
    }
}
