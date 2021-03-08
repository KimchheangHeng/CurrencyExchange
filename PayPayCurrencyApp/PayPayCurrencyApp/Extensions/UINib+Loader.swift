//
//  UINib+Loader.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 4/3/21.
//

import UIKit

protocol NibViewIdentifier { }
protocol NibControllerIdentifier { }

// MARK: - UINib
extension UINib: NibViewIdentifier {
    static func nibName() -> String {
        return "\(self)"
    }
    
    static func nib(named nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}

extension NibViewIdentifier where Self: UINib {
    static func instantiateNib(from owner: Any?) -> Self {
        return nib(named: nibName()).instantiate(withOwner: owner, options: nil).first as! Self
    }
}

// MARK: - UIViewController
extension UIViewController: NibControllerIdentifier {
    class func nibName() -> String {
        return "\(self)"
    }
}

extension NibControllerIdentifier where Self: UIViewController {
    static func instantiateFromNib() -> Self {
        return Self(nibName: self.nibName(), bundle:nil)
    }
}

// MARK: - View
extension UIView {
    class func nibName() -> String {
        return "\(self)"
    }
    
    class func instanceFromNib() -> UIView {
        let loadedView = UINib(nibName: nibName(), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        loadedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadedView.translatesAutoresizingMaskIntoConstraints = false
        return loadedView
    }
    
    class func instanceFromNib(name: String) -> UIView {
        return UINib(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func setConstraintToSuperView() {
        guard let superview = self.superview else { return }
        
        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
    }
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        let xibName = String(describing: type(of: self))
        
        guard let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?[0] as? T else {
            // xib not loaded, or it's top view is of the wrong type
            return nil
        }
        self.addSubview(view)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        return view
    }
}

