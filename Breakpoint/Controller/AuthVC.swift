//
//  AuthVC.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/7/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class AuthVC: UIViewController, FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if ((error) != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // Navigate to other view
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    

    @IBOutlet var FBLogin: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        FBLogin.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            dismiss(animated: true, completion: nil)
        }
   // let loginButton = FBLogin(readPermissions: [ .publicProfile ])
    
//        if let accessToken = FBSDKAccessToken.current {
//            // User is logged in, use 'accessToken' here.
//        }
        
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
