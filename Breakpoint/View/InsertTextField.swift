//
//  InsertTextField.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/7/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit

//@IBDesignable
class InsetTextField: UITextField {

    
    
    override func awakeFromNib() {
        setupView()

        super.awakeFromNib()
    }
//    override func prepareForInterfaceBuilder() {
//        setupView()
//    }
    private var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    fileprivate func setupView() {
        let placholder = NSAttributedString(string: self.placeholder! , attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        self.attributedPlaceholder = placholder
    }
}
