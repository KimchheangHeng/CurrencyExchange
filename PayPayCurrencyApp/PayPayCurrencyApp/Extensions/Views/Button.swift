//
//  Button.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 4/3/21.
//

import UIKit

@IBDesignable
class Button: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable
    var roundButton: Bool = false {
        didSet {
            if roundButton {
                layer.cornerRadius = frame.height / 2
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var titleImageHorizontalSpace: CGFloat = 0.0 {
        didSet {
            if semanticContentAttribute == .forceRightToLeft {
                titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: titleImageHorizontalSpace / 2)
                imageEdgeInsets = UIEdgeInsets(top: 0, left: titleImageHorizontalSpace / 2, bottom: 0, right: 0)
            } else {
                titleEdgeInsets = UIEdgeInsets(top: 0, left: titleImageHorizontalSpace / 2, bottom: 0, right: 0)
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: titleImageHorizontalSpace / 2)
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentHorizontalAlignment = .center
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.lineBreakMode = .byTruncatingTail
        titleLabel?.numberOfLines = 1
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        if roundButton {
            layer.cornerRadius = frame.height / 2
        }
    }
    
    func renderColor(color: UIColor) {
        let templateImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.imageView?.image = templateImage
        self.tintColor = color
    }
}

