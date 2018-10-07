//
//  AuthService.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/8/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
import Firebase

class AuthService{
    static let instance = AuthService()
    
    func createUser(WithEmail email: String, andPassword password: String, completionHandler: @escaping (_ success: Bool,_ error: Error?) -> ()){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                completionHandler(false, error)
                return
            }
            let userData = ["provider": user.providerID, "email": user.email]
            DataService.instance.createDBUser(uid: user.uid, userData: userData as Dictionary<String, Any>)
            completionHandler(true, nil)

        }
    }
    func loginUser(WithEmail email: String, andPassword password: String, completionHandler: @escaping (_ success: Bool,_ error: Error?) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                completionHandler(false, error)
                return
            }
            let _ = user.email
            completionHandler(true, nil)
        }
    }
}
