//
//  FirstViewController.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/3/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    @IBOutlet var tabelView: UITableView!
    var messageArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tabelView.delegate = self
        tabelView.dataSource = self
       
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // messageArray.removeAll()
       // tabelView.reloadData()
       
        DataService.instance.getAllFeedMessage { (messages) in
            self.messageArray = messages.reversed()
            self.tabelView.reloadData()
        }
    }
    
    @IBAction func composeButtonWasPressed(_ sender: UIButton) {
        let createPostVC = storyboard?.instantiateViewController(withIdentifier: "CreatePostVC") as! CreatePostVC
        presentDetails(createPostVC)
    }
    
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell{
            let message = messageArray[indexPath.row]
            DataService.instance.getUsername(forUID: message.senderId) { (returnedUsernamr) in
                DataService.instance.getUsrPhoto(uid: message.senderId, completion: { (photourl) in
                    cell.configCell(message: message, email: returnedUsernamr, photo: photourl)

                })
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
}
