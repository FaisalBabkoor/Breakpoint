//
//  GroupFeedCell.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/16/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    override func awakeFromNib() {
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        emailLbl.text = ""
        contentLbl.text = ""
        super.awakeFromNib()
    }
    func configureCell(profileImage: String, email: String, content: String) {
        
        DataService.instance.getUsrPhoto(uid: profileImage, completion: { (urlPhoto) in
            
            guard let url = URL(string: urlPhoto) else {return}
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil{
                    print(String(describing: error))
                    return
                }
                guard let data = data else {return}
                guard let imageProfile = UIImage(data: data) else {return}
                DispatchQueue.main.async {
                    self.profileImage.image = imageProfile
                    self.emailLbl.text = email
                    self.contentLbl.text = content
                }
                
            }).resume()
        })
        
        
     
        
    }
    

}
