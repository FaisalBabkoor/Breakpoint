//
//  GroupCell.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/16/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    
    
    func config(title: String, description: String, number: Int){
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        if number > 1{
            self.numberLabel.text = "\(number) members"
        }else{
            self.numberLabel.text = "\(number) member"
        }
    }
    
}
