//
//  DataService.swift
//  Breakpoint
//
//  Created by Faisal Babkoor on 9/3/18.
//  Copyright © 2018 Faisal Babkoor. All rights reserved.
//

import Foundation
import Firebase
var DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    private var _REF_PHOTO = DB_BASE.child("photo")
    private var _REF_BIO = DB_BASE.child("bio")
    
    var REF_BIO: DatabaseReference {
        return _REF_BIO
    }
    var REF_PHOTO: DatabaseReference {
        return _REF_PHOTO
    }
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    func createDBUser(uid: String,userData: Dictionary<String, Any> ){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func creatPost(whithMessage message: String,forUID uid: String,withGroupKey groupKey: String?, completionHandler: @escaping (_ success: Bool) -> ()){
        if groupKey != nil{
            // send to groups
            REF_GROUPS.child(groupKey!).child("message").childByAutoId().updateChildValues(["content" : message, "senderId": uid])
            completionHandler(true)
        }else{
            REF_FEED.childByAutoId().updateChildValues(["content" : message, "senderId": uid])
            completionHandler(true)
        }
    }
    
    func getUsername(forUID uid: String, completion: @escaping (_ username: String)->()){
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot{
                if user.key == uid{
                    completion(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func converIdToEmail(id : String, completion: @escaping (_ email: String) -> ()){
        REF_USERS.observeSingleEvent(of: .value) { (emailSnapshot) in
            guard let emailSnapshot = emailSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for email in emailSnapshot{
                if id == email.key{
                    let em = email.childSnapshot(forPath: "email").value as! String
                    completion(em)
                }
            }
            
        }
    }
    
    func getAllGroupMessage(groupKey: Group,completion: @escaping (_ groupMessage: [Message]) -> ()){
        var groupMessageArray = [Message]()
        REF_GROUPS.child(groupKey.key).child("message").observeSingleEvent(of: .value) { (returnedGroupMessage) in
            guard let returnedGroupMessage = returnedGroupMessage.children.allObjects as? [DataSnapshot] else {return}
            for message in returnedGroupMessage{
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let groupMessage = Message(content: content, senderId: senderId)
                groupMessageArray.append(groupMessage)
            }
            completion(groupMessageArray)
        }
    }
    func getAllFeedMessage(completion: @escaping (_ messages: [Message]) -> ()){
        var messageArray = [Message]()
        
        REF_FEED.observeSingleEvent(of: .value) {(feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for message in feedMessageSnapshot{
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                messageArray.append(message)
            }
            completion(messageArray)
        }
    }
    func getEmail(forSearchQuery query: String, completion: @escaping (_ emailArray: [String])->()){
        var emailArray = [String]()
        
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for email in userSnapshot{
                let emailUser = email.childSnapshot(forPath: "email").value as! String
                if emailUser.contains(query) == true && emailUser != Auth.auth().currentUser?.email{
                    emailArray.append(emailUser)
                }
            }
            completion(emailArray)
        }
    }
    
    func getIds(forEmail email: [String], completion: @escaping (_ ids: [String]) -> ()){
        var idsArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSanpshot) in
            guard let userSanpshot = userSanpshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSanpshot{
                let emailUser = user.childSnapshot(forPath: "email").value as! String
                
                if email.contains(emailUser){
                    idsArray.append(user.key)
                }
            }
            completion(idsArray)
        }
    }
    func getEmailFor(group: Group, completion: @escaping (_ emailArray: [String]) -> ()){
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (emailSnapshot) in
            guard let emailSnapshot = emailSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for email in emailSnapshot{
                if group.members.contains(email.key){
                    let emailUser = email.childSnapshot(forPath: "email").value as! String
                    emailArray.append(emailUser)
                }
            }
            completion(emailArray)
        }
    }
    func createGroup(title: String, description: String, users: [String], completionHandler: @escaping (_ success: Bool) -> ()){
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "users": users])
        completionHandler(true)
    }
    
    func getAllGroups(completion: @escaping (_ group: [Group]) -> ()){
        var groupsArray = [Group]()
        REF_GROUPS.observe(.value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for group in groupSnapshot{
                let users = group.childSnapshot(forPath: "users").value as! [String]
                if users.contains((Auth.auth().currentUser?.uid)!){
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    let key = group.key
                    
                    let group = Group(title: title, description: description, members: users, key: key)
                    groupsArray.append(group)
                }
                
                
            }
            completion(groupsArray)
        }
    }
    
    func uploadPhoto(uid: String, image: UIImage ,completionHandler: @escaping (_ success: Bool) -> ()){
        let uuid = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profileImage").child("\(uuid).jpg")
        if let uploadData = image.jpegData(compressionQuality: 0.1){
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil{
                    print("Can't upload photo")
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    guard let url = url?.absoluteString else {return}
                    self.REF_PHOTO.childByAutoId().updateChildValues(["userId": uid,"photoURL": url])
                })
                completionHandler(true)
            }

        }
    }
    func getUserFeed(uid: String, completion: @escaping (_ messages: [String]) -> ()){
        var userMessages = [String]()
        REF_FEED.observe(.value) { (snapshot) in
            guard let feeds = snapshot.children.allObjects as? [DataSnapshot] else {return}
            for feed in feeds{
                let senderId = feed.childSnapshot(forPath: "senderId").value as! String
                if senderId == uid{
                    let content = feed.childSnapshot(forPath: "content").value as! String
                    userMessages.append(content)
                }
            }
            self.REF_GROUPS.observe(.value, with: { (snap) in
                guard let snap = snap.children.allObjects as? [DataSnapshot] else {return}
                for inn in snap{
                    let cont = inn.childSnapshot(forPath: "message").children.allObjects as! [DataSnapshot]
                    for message in cont{
                        let sender = message.childSnapshot(forPath: "senderId").value as! String
                        if sender == uid{
                            let content = message.childSnapshot(forPath: "content").value as! String
                            userMessages.append(content)
                        }
                    }
                }
                completion(userMessages)
            })
           // completion(userMessages)

        }
 
        
    }
    
    func createBio(uid: String, bio: String ,completionHandler: @escaping (_ success: Bool) -> ()){
        REF_BIO.childByAutoId().updateChildValues(["userId":uid,"bio":bio])
        completionHandler(true)
    }
    func getBio(uid: String,completionHandler: @escaping (_ bio: String) -> ()){
        REF_BIO.observeSingleEvent(of: .value) { (bioSnapshot) in
            guard let bios = bioSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for bio in bios{
                let userId = bio.childSnapshot(forPath: "userId").value as! String
                let bio = bio.childSnapshot(forPath: "bio").value as! String
                if uid == userId{
                    completionHandler(bio)
                }
            }
        }
    }
    func getUsrPhoto(uid: String, completion: @escaping (_ photo: String) -> ()){
        REF_PHOTO.observeSingleEvent(of: .value) { (photo) in
            guard let photos = photo.children.allObjects as? [DataSnapshot] else {return}
            for photo in photos{
                let userId = photo.childSnapshot(forPath: "userId").value as! String
                let url = photo.childSnapshot(forPath: "photoURL").value as! String
                if uid == userId{
                    completion(url)
                }
            }
        }
    }
}
