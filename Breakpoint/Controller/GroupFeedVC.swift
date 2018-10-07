//
//  GroupFeedVC.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/16/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
import Firebase
class GroupFeedVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var membersLbl: UILabel!
    @IBOutlet var grouptitleLbl: UILabel!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var messageTextField: InsetTextField!
    @IBOutlet var sendBtnView: UIView!
    
    var group: Group?
    var groupMessages = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        sendBtnView.bindKeyboard()
        hideKeyboard()
        //        messageTextField.inputAccessoryView = sendBtnView
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let group = group else {return}
        self.grouptitleLbl.text = group.title
        DataService.instance.getEmailFor(group: group) { (returnedEmail) in
            self.membersLbl.text = returnedEmail.joined(separator: ", ")
        }
        
        DataService.init().REF_GROUPS.observe(.value) { (_) in
            DataService.instance.getAllGroupMessage(groupKey: group) { (groupMessages) in
                self.groupMessages = groupMessages
                self.tableView.reloadData()
                
                if groupMessages.count > 0{
                    self.tableView.scrollToRow(at: IndexPath(row: groupMessages.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
                }
            }
        }
        
        
    }
    
    
    func hideKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreatePostVC.dismissView(_:)))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissView(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    @IBAction func sendButtonWasPressed(_ sender: UIButton) {
        if messageTextField.text != ""{
            sendBtn.isEnabled = false
            messageTextField.isEnabled = false
            DataService.instance.creatPost(whithMessage: messageTextField.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.key) { (success) in
                if success{
                    self.messageTextField.text = ""
                    self.sendBtn.isEnabled = true
                    self.messageTextField.isEnabled = true
                }
            }
        }
    }
    
    @IBAction func backButtonWasPressed(_ sender: UIButton) {
        dismissDetails()
    }
    
}
extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupFeedCell", for: indexPath) as? GroupFeedCell{
            let groupMessage = groupMessages[indexPath.row]
            
                        DataService.instance.converIdToEmail(id: groupMessage.senderId) { (email) in
            
                            cell.configureCell(profileImage: groupMessage.senderId, email: email, content: groupMessage.content)
                        }
            
      
            return cell
        }else{
            return UITableViewCell(style: .default, reuseIdentifier: "GroupFeedCell")
        }
    }
}
