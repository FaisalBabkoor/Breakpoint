//
//  SecondViewController.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/3/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var groupInfo = [Group]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getAllGroups { (group) in
            self.groupInfo = group
            self.tableView.reloadData()
        }
    }
    @IBAction func createGroup(_ sender: UIButton) {
        let createGroupVC = storyboard?.instantiateViewController(withIdentifier: "CreateGroupVC") as! CreateGroupVC
        presentDetails(createGroupVC)
    }
    
}
extension GroupsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupInfo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell{
            let group = groupInfo[indexPath.row]
            cell.config(title: group.title, description: group.description, number: group.members.count)
            return cell
        }else{
            return UITableViewCell(style: .default, reuseIdentifier: "groupCell")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if let goalFeedVC = storyboard?.instantiateViewController(withIdentifier: "GroupFeedVC") as? GroupFeedVC{
        goalFeedVC.group = groupInfo[indexPath.row]
        present(goalFeedVC, animated: true, completion: nil)
        }
    }
}
