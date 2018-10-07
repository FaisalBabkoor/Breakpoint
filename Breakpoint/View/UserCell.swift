//
//  UserCell.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/12/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var checkImage: UIImageView!
    var showingCheckMarik = false

    func config(profileImage: UIImage, email: String, isSelected: Bool ){
        self.profileImage.image = profileImage
        self.emailLbl.text = email
        self.showingCheckMarik = isSelected
        if isSelected{
            self.checkImage.isHidden = false
        }else{
            self.checkImage.isHidden = true
        }
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            if showingCheckMarik == false{
                checkImage.isHidden = false
                showingCheckMarik = !showingCheckMarik
            }else if showingCheckMarik == true{
                checkImage.isHidden = true
                showingCheckMarik = !showingCheckMarik
            }
        }
        // Configure the view for the selected state
    }

}
