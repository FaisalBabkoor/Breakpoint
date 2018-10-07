//
//  MeVC.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/8/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import UIKit
import Firebase
class MeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var bio: UITextField!

    @IBOutlet var doneButton: UIButton!
    var feedsArray = [String]()
    var isDone = false
    override func viewDidLoad() {
        super.viewDidLoad()
        bio.delegate = self
        tabelView.delegate = self
        tabelView.dataSource = self
        // Do any additional setup after loading the view.
        if isDone{
            doneButton.titleLabel?.text = "Done"
        }else{
            doneButton.titleLabel?.text = "Edit"
        }
        imageProfile.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handelToChangePhoto))
        imageProfile.addGestureRecognizer(tap)
        imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
        
        DataService.instance.getUsrPhoto(uid: (Auth.auth().currentUser?.uid)!) { (urlPhoto) in
            guard let url = URL(string: urlPhoto) else {return}
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil{
                    print(String(describing: error))
                    return
                }
                guard let data = data else {return}
                DispatchQueue.main.async {
                    self.imageProfile.image = UIImage(data: data)
                }
            }).resume()
        }
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLbl.text = Auth.auth().currentUser?.email
        DataService.instance.getUserFeed(uid: (Auth.auth().currentUser?.uid)!) { (feeds) in
            self.feedsArray = feeds
            self.tabelView.reloadData()
        }
        DataService.instance.getBio(uid: (Auth.auth().currentUser?.uid)!) { (bio) in
            self.bio.text = bio
        }

    }
    
    
    @IBAction func doneWasPressed(_ sender: UIButton) {
        if self.bio.isEditing{
            if bio.text != ""{
                guard let bio = bio.text else {return}
                DataService.instance.createBio(uid: (Auth.auth().currentUser?.uid)!, bio: bio) { (success) in
                    if success{
                        //self.doneButton.isHidden = true
                        self.isDone = false
                        self.doneButton.titleLabel?.text = "Edite"

                    }
                }
            }
        }else{
            if !self.bio.isEditing{
                self.doneButton.titleLabel?.text = "Done"
                self.isDone = false

            }
        }
   
    }
    
 
    @objc func handelToChangePhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage{
            selectedImage = editedImage
        }else if let livePhoto = info[.livePhoto] as? UIImage{
            selectedImage = livePhoto
        }else if let originalImage = info[.originalImage] as? UIImage{
            selectedImage = originalImage
        }
        
        if let selectedImage = selectedImage{
            imageProfile.image = selectedImage
            DataService.instance.uploadPhoto(uid: (Auth.auth().currentUser?.uid)!, image: selectedImage) { (success) in
                if success{
                    self.dismissDetails()
                }
            }

        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismissDetails()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.emailLbl.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func logouBtnWasPressed(_ sender: UIButton) {
     let alert = UIAlertController(title: "Logout?", message: "Are you sure you want logout?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Logout", style: .destructive) { (_) in
            do{
              try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                 let authVC = storyboard.instantiateViewController(withIdentifier: "AuthVC") as! AuthVC
                self.present(authVC, animated: true, completion: nil)
            }catch{
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        present(alert, animated: true) {
            self.imageProfile.image = #imageLiteral(resourceName: "defaultProfileImage")
            self.emailLbl.text = ""
            self.bio.text = ""
            self.feedsArray = []
            self.tabelView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        cell.textLabel?.text = feedsArray[indexPath.row]
        
            return cell
        
    }
    
}
extension MeVC: UITextFieldDelegate{
    private func textFieldShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.doneButton.isHidden = false
        if bio.isEditing{
        
        if bio.text == "bio..." {
            bio.text = ""
            return true
        }else{
            return true
        }
        }else{
            return false
        }
    }
    
    private func textFieldShouldEndEditing(_ textView: UITextView) -> Bool {
        self.doneButton.isHidden = false
        if bio.isEditing{
            
        if bio.text == ""{
            bio.text = "bio..."
            self.doneButton.isHidden = false
            return true

        }else{
            self.doneButton.isHidden = false

            return true

        }
        } else{
            return false
        }
    }
}
