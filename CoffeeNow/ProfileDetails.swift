//
//  ProfileDetails.swift
//  CoffeeNow
//
//  Created by admin on 12/11/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase

class ProfileDetails: NSObject {
    
    var allDetailsDictionary: [String: Any]?
    
    static let sharedInstance = ProfileDetails()
    
    override init() {
        super.init()
        
    }

    func setProfileDetails(profileDictionary: [String: Any]) {
        allDetailsDictionary = profileDictionary
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        updateUserDetailsIntoDataBaseWithUID(uid: uid, values: allDetailsDictionary!)
    }
    func getProfileDetails() -> [String: Any]? {
        return allDetailsDictionary
    }
    
    private func updateUserDetailsIntoDataBaseWithUID(uid: String, values: [String: Any]) {
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users-details").child(uid)
        userReference.updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        }
    }
    
    func fetchUserInfofromServer(uid: String, completion: @escaping ([String: Any]) -> ()){
        FIRDatabase.database().reference().child("users-details").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userDetailsDictionary = snapshot.value as? [String: Any] {
                completion(userDetailsDictionary)
            }
        }, withCancel: nil)
    }
    func fetchUserPermissions(fromId: String, toId: String, completion: @escaping ([String: Any]) -> ()){
        let uid = toId + fromId
        print("fetching perform for toId + fromId:", uid)
        FIRDatabase.database().reference().child("contacts-permissions").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userDetailsDictionary = snapshot.value as? [String: Any] {
                completion(userDetailsDictionary)
                print("permissions", userDetailsDictionary)
            } else {
                print("Default permissions")
                let userDefaultDetails = ["infoRequested":"No", "grantPermission":"No"]
                completion(userDefaultDetails)
            }
        }, withCancel: nil)
    }
}
