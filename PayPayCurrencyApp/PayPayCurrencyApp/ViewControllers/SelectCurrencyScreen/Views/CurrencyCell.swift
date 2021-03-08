//
//  CurrencyCell.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 7/3/21.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
    
    // MARK: - Setup UI
    func configView(with viewModel: CurrencyViewModel) {
        flagImageView.image = viewModel.flagImage
        currencyCodeLabel.text = viewModel.displayCode
        currencyNameLabel.text = viewModel.displayName
    }
}
