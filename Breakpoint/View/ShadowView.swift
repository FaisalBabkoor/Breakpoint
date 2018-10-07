//
//  ShadowView.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/8/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
//@IBDesignable
class ShadowView: UIView {


    
    override func awakeFromNib() {
        setupView()
        super.awakeFromNib()
    }
//    override func prepareForInterfaceBuilder() {
//        setupView()
//    }
    fileprivate func setupView() {
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOpacity = 0.75
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 10
    }
}
