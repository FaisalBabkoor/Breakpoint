//
//  AuthVC.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/7/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {

    
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            dismiss(animated: true, completion: nil)
        }
   
    }
    @IBAction func signInWithEmailBtnWasPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        present(loginVC, animated: true, completion: nil)
        
    }
    
    @IBAction func facebookSignInBtnWasPressed(_ sender: Any) {
       
        
    }
    
    @IBAction func googleSignInBtnWasPressed(_ sender: Any) {
    }
    

}
