//
//  ContactsController.swift
//  CoffeeNow
//
//  Created by Roman Sheydvasser on 1/21/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase

class ContactsController: UITableViewController {
    
    let cellId = "cellId"
    var loggedInId: String!
    private var otherUserPermissions = [String: Any]()
    private var allowDetails = false
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        loggedInId = uid
        
        fetchConnectedUsers()
    }
    
    func checkPermissions() {
        allowDetails = false
        var blocked = false
        if let blockUser = otherUserPermissions["blockUser"] as? String {
            if blockUser == "Yes" {
                allowDetails = false
                blocked = true
            }
        }
        if blocked == false {
            if let permissionGranted = otherUserPermissions["grantPermission"] as? String {
                if permissionGranted == "Yes" {
                    allowDetails = true
                } else {
                    allowDetails = false
                }
            }
        }
    }
    
    func fetchConnectedUsers() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                
                //check for connected users
                if let uid = user.id {
                    ProfileDetails.sharedInstance.fetchUserPermissions(fromId: self.loggedInId, toId: uid) { (permissionDetails) in
                        self.otherUserPermissions = permissionDetails
                    }
                }
                self.checkPermissions()
                
                if self.allowDetails {
                    //if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                    user.setValuesForKeys(dictionary)
                    self.users.append(user)
                    
                    //this will crash because of background thread, so lets use dispatch_async to fix
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        }, withCancel: nil)
    }
    
    func handleBack() {
        navigationController?.pop(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user)
            
            //let layout = UICollectionViewFlowLayout()
            //let profileDetailsController = UserProfileCollectionVC(collectionViewLayout: layout)
            
            /*
            let profileDetailsController = UserProfileCollectionVC()

            profileDetailsController.profileBasicInfo = selectedAnno
            let selectedProfileID = selectedAnno.userNumber
            profileDetailsController.contactId = selectedProfileID
            profileDetailsController.contactDetailDictionary = selectedUserDetails
            
            profileDetailsController.permissionsDictionary = selectedUserpermissions

            
            self.navigationController?.pushViewController(profileDetailsController, animated: true)
            */
        }
    }
}
