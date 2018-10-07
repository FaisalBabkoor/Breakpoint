//
//  LoginVC.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/7/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: InsetTextField!
    
    @IBOutlet weak var passwordTextField: InsetTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInBtnWasPressed(_ sender: Any) {
        if let email = emailTextField.text, let pass = passwordTextField.text{
            AuthService.instance.loginUser(WithEmail: email, andPassword: pass) { (success, error) in
                if success{
                    self.dismiss(animated: true, completion: nil)
                }else{
                    print(String(describing: error))
                }
                
                AuthService.instance.createUser(WithEmail: email, andPassword: pass
                    , completionHandler: { (success, error) in
                        if success{
                            self.dismiss(animated: true, completion: nil)
                        }else{
                            print(String(describing: error))
                        }
                })
            }
        }
        
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
