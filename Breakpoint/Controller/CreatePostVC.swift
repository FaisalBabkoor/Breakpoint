//
//  CreatePostVC.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/9/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
import Firebase
class CreatePostVC: UIViewController {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var texView: UITextView!
    @IBOutlet var sendButton: UIButton!
    let textViewPalceholder = "Say somthing here..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.bindKeyboard()
        texView.delegate = self
        // texView.bindKeyboard()
        
        // Do any additional setup after loading the view.
        hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.emailLabel.text = Auth.auth().currentUser?.email
    }
    
    func hideKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreatePostVC.dismissView(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissView(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @IBAction func sendButtonWasPressed(_ sender: UIButton) {
        if texView.text != nil && texView.text != textViewPalceholder{
            DataService.instance.creatPost(whithMessage: texView.text, forUID: (Auth.auth().currentUser?.uid)! , withGroupKey: nil) { (success) in
                if success{
                    UIPasteboard.general.string = self.texView.text
                    self.sendButton.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.sendButton.isEnabled = false
                }
            }
        }
    }
    
    @IBAction func closeButtonWasPressed(_ sender: UIButton) {
        dismissDetails()
        
    }
}
extension CreatePostVC: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == textViewPalceholder {
            textView.text = ""
            return true
        }else{
            return true
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == ""{
            textView.text = textViewPalceholder
            return true
        }else{
            return true
        }
    }
}


