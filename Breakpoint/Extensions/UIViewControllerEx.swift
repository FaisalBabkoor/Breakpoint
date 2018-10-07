//
//  UIViewControllerEx.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/17/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
extension UIViewController{
    func presentDetails(_ viewControllerToPresent: UIViewController){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func dismissDetails(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
}
