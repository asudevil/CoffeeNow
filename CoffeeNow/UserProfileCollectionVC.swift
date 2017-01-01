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
    var allowDetails = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        self.collectionView!.register(UserProfileDetailsCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView?.register(UserHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        setupProfileDetailsArray()
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
            contactInfoArray.append("to get request contact info")
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

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
        print("Request Button Clicked")
    }
    
    func saveUserToContacts(sender: UITapGestureRecognizer) {
        print("Save User to Contacts Clicked")
        
        let alertTitle = "Save contact"
        let alertMessage = "Would you like to save this contact to your phone contacts list?"
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        let addContactAction = UIAlertAction(title: "Add Contact", style: .default) { (action) in
            self.addContact(contactInfoToSave: self.contactDetailDictionary)
        }
        alert.addAction(cancelAction)
        alert.addAction(addContactAction)
        self.present(alert, animated: true, completion: nil)

    }
    
    func shareUserTapped(sender: UITapGestureRecognizer) {
        print("Share Button Clicked")
    }
    func blockUserTapped(sender: UITapGestureRecognizer) {
        print("Block Button Clicked")
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
    
    func alertTaskComplete(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
