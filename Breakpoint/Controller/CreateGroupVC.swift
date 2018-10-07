//
//  CreateGroupVC.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/11/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
import Firebase
class CreateGroupVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var tabelView: UITableView!
    @IBOutlet var titleTextField: InsetTextField!
    @IBOutlet var descriptionTextField: InsetTextField!
    @IBOutlet var emailTextField: InsetTextField!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var groupNamesLbl: UILabel!
    var emailArray = [String]()
    var emailWasSelected = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        tabelView.delegate = self
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldDidChanged), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChanged(){
        if emailTextField.text == "" || emailTextField.text == nil{
            emailArray = []
            tabelView.reloadData()
        }else{
            DataService.instance.getEmail(forSearchQuery: emailTextField.text!) { (emails) in
                self.emailArray = emails
                self.tabelView.reloadData()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
     
    }
    @IBAction func doneButtonWasPressed(_ sender: UIButton) {
        if titleTextField.text != "" && descriptionTextField.text != ""{
            var idsAray = [String]()
            DataService.instance.getIds(forEmail: emailWasSelected) { (ids) in
                idsAray = ids
                idsAray.append((Auth.auth().currentUser?.uid)!)
                DataService.instance.createGroup(title:self.titleTextField.text!, description: self.descriptionTextField.text!, users: idsAray, completionHandler: { (success) in
                    if success{
                        self.dismissDetails()
                    }
                })
            }
        }
        
    }
    
    
    @IBAction func closeButtonWasPressed(_ sender: UIButton) {
        dismissDetails()
    }
}
extension CreateGroupVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tabelView.dequeueReusableCell(withIdentifier: createGorupCellId, for: indexPath) as? UserCell{
            if emailWasSelected.contains(emailArray[indexPath.row]){
                cell.config(profileImage: #imageLiteral(resourceName: "defaultProfileImage"), email: emailArray[indexPath.row], isSelected: true)

            }else{
                cell.config(profileImage: #imageLiteral(resourceName: "defaultProfileImage"), email: emailArray[indexPath.row], isSelected: false)

            }
            return cell
       }else{
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else {return}
        guard let emailLbl = cell.emailLbl.text else {return}
        if !emailWasSelected.contains(emailLbl){
            emailWasSelected.append(emailLbl)
            groupNamesLbl.text = emailWasSelected.joined(separator: ", ")
            self.doneButton.isHidden = false
        }else{
            emailWasSelected = emailWasSelected.filter({ (email) -> Bool in
                email != emailLbl
            })
            if emailWasSelected.count >= 1{
                groupNamesLbl.text = emailWasSelected.joined(separator: ", ")
            }else{
                groupNamesLbl.text = "add people to your group"
                self.doneButton.isHidden = true

            }

        }
    }
}
