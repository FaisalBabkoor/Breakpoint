//
//  FeedCell.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/10/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
import Firebase
class FeedCell: UITableViewCell {
    
    @IBOutlet var imageProfile: UIImageView!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var messageLbl: UILabel!
    
    func configCell(message: Message, email: String, photo: String){
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: photo) else {return}

        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil{
                print(String(describing: error))
                return
            }
            guard let data = data else {return}
            guard let image = UIImage(data: data) else {return}
            DispatchQueue.main.async {
                self.emailLbl.text = email
                self.messageLbl.text = message.content
                self.imageProfile.image = image
            }
//        self.emailLbl.text = email
//        self.messageLbl.text = message.content
//        self.imageProfile.image = UIImage(named: "defaultProfileImage")
    }).resume()
        }
    }
    override func awakeFromNib() {
        emailLbl.text = ""
        messageLbl.text = ""
        imageProfile.image = UIImage(named: "defaultProfileImage")
        imageProfile.layer.cornerRadius = imageProfile.frame.width / 2
        imageProfile.clipsToBounds = true
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
