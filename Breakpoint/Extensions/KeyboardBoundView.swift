//
//  KeyboardBoundView.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/9/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit

extension UIView{
    func bindKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: Notification){
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let startFrame = notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let endFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let deltaY = endFrame.origin.y - startFrame.origin.y
       
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions.init(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: { (true) in
            self.layoutIfNeeded()
        })
    }
}

