//
//  UserProfileCollectionVC.swift
//  CoffeeNow
//
//  Created by admin on 12/28/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase
import Contacts

private let cellId = "Cell"
private let headerId = "HeaderId"

class UserProfileCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var store = CNContactStore()

    var profileBasicInfo: UserAnnotation?
    var contactId: String?
    var contactInfoArray = [String]()
    var contactDetailDictionary = [String: Any]()
    var profileLabels = [String]()
    
    var permissionsDictionary = [String: Any]()
    var contactLocation: CLLocationCoordinate2D!
    private var allowDetails = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        self.collectionView!.register(UserProfileDetailsCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView?.register(UserHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        setupPermissions()
        setupProfileDetailsArray()
    }
    
    func setupPermissions() {
        allowDetails = false
        var blocked = false
        if let blockUser = permissionsDictionary["blockUser"] as? String {
            if blockUser == "Yes" {
                allowDetails = false
                blocked = true
            }
        }
        if blocked == false {
            if let permissionGranted = permissionsDictionary["grantPermission"] as? String {
                if permissionGranted == "Yes" {
                    allowDetails = true
                } else {
                    allowDetails = false
                }
            }
        }
    }
    
    func setupProfileDetailsArray() {
        
        guard let contactUserName = profileBasicInfo?.title, let contactImageUrl = profileBasicInfo?.imageUrl else { return }
        
        profileLabels.append("User Picture URL: ")
        contactInfoArray.append(contactImageUrl)
        
        profileLabels.append("User Name: ")
        contactInfoArray.append(contactUserName)
        
        if allowDetails {
            let infoDetailsLabels = ["First Name", "Last Name", "Location", "Email", "Phone", "Gender", "Occupation", "LinkedIn", "More Info"]
            let infoKeys = ["firstName", "lastName", "location", "email", "phone", "gender", "occupation", "linkedIn", "details"]
            
            var count = 0
            for infoLabel in infoDetailsLabels {
                loadInfoDetailsArray(infoLabel: infoLabel, infoKey: infoKeys[count])
                count += 1
            }
        } else {
            profileLabels.append("Tap request ")
            contactInfoArray.append("to request this user's contact info")
        }
    }
    
    func loadInfoDetailsArray(infoLabel: String, infoKey: String) {
        if let userName = contactDetailDictionary[infoKey] as? String {
            self.contactInfoArray.append(userName)
            self.profileLabels.append(infoLabel)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactInfoArray.count - 2 //first 2 are header info
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfileDetailsCell
        
        cell.titleLabel.text = profileLabels[indexPath.row + 2]
        cell.title.text = contactInfoArray[indexPath.row + 2]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 30)
    }
    
    //Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserHeaderCell
        
        let userPicUrl = contactInfoArray[0]
        header.profileImageView.loadImageUsingCacheWithUrlString(urlString: userPicUrl)
        header.name.text = contactInfoArray[1]
                
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 210)
    }
    
    //These function are for buttons inside the header cell.  Strange but have to implement it here too.
    func tappedMessageBtn(sender: UITapGestureRecognizer) {
        print("CollectionView Messages function Button Clicked")
        showChatFromProfileView()
    }
    
    func requestUserInfoTapped(sender: UITapGestureRecognizer) {
        let alertTitle = "Request Info"
        let alertMessage = "Would you like to request contact information from this user?"
        let request = "infoRequested"
        alertPerformTask(alertTitle: alertTitle, alertMessage: alertMessage) { (action) in
            self.handleShareRequests(requestType: request, success: { (successful) in
                if successful {
                    self.alertTaskComplete(taskTitle: "Request Sent", confirmation: "Request sent to user")
                } else {
                    self.alertTaskComplete(taskTitle: "ERROR", confirmation: "Error processing this request.  Please try again")
                }
            })
        }
    }
    
    func saveUserToContacts(sender: UITapGestureRecognizer) {
        
        let alertTitle = "Save contact"
        let alertMessage = "Would you like to save this contact to your phone contacts list?"
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        let addContactAction = UIAlertAction(title: "Add Contact", style: .default) { (action) in
            self.addContact(contactInfoToSave: self.contactDetailDictionary)
            self.alertTaskComplete(taskTitle: "User Saved", confirmation: "This user has been saved to your iPhone contacts")
        }
        alert.addAction(cancelAction)
        alert.addAction(addContactAction)
        self.present(alert, animated: true, completion: nil)

    }
    
    func shareUserTapped(sender: UITapGestureRecognizer) {
        let alertTitle = "Share My Info"
        let alertMessage = "Would you like to share your user information with this contact?"
        let request = "grantPermission"

        alertPerformTask(alertTitle: alertTitle, alertMessage: alertMessage) { (action) in
            self.handleShareRequests(requestType: request, success: { (successful) in
                if successful {
                    self.alertTaskComplete(taskTitle: "Permission Granted", confirmation: "This user has been granted access to your contact information")
                } else {
                    self.alertTaskComplete(taskTitle: "ERROR", confirmation: "Error processing this request.  Please try again")
                }
            })
        }
    }
    func blockUserTapped(sender: UITapGestureRecognizer) {
        let alertTitle = "Block User"
        let alertMessage = "Are you sure you want to block this user?"
        let request = "blockUser"
        
        alertPerformTask(alertTitle: alertTitle, alertMessage: alertMessage) { (action) in
            self.handleShareRequests(requestType: request, success: { (successful) in
                if successful {
                    self.alertTaskComplete(taskTitle: "User Blocked", confirmation: "This user has been blocked from seeing your contacts and activities")
                } else {
                    self.alertTaskComplete(taskTitle: "ERROR", confirmation: "Error processing this request.  Please try again")
                }
            })
        }
    }
    
    func showChatFromProfileView() {
        guard let contactUserName = profileBasicInfo?.title, let contactImageUrl = profileBasicInfo?.imageUrl else { return }
        let userToChatWith = User()
        userToChatWith.id = contactId
        userToChatWith.name = contactUserName
        userToChatWith.profileImageUrl = contactImageUrl
        
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = userToChatWith
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func alertTaskComplete(taskTitle: String, confirmation: String) {
        let alert = UIAlertController(title: taskTitle, message: confirmation, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func alertPerformTask(alertTitle: String, alertMessage: String, completion: @escaping(UIAlertAction) -> ()) {
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        let actionToPerform = UIAlertAction(title: alertTitle, style: .default) { (action) in
            completion(action)
        }
        alert.addAction(cancelAction)
        alert.addAction(actionToPerform)
        self.present(alert, animated: true, completion: nil)
    }
}
