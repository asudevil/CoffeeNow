//
//  ProfileDetails.swift
//  CoffeeNow
//
//  Created by admin on 12/11/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class ProfileDetails: NSObject {
    
//    fileprivate var imageUrl: String?
//    fileprivate var username: String?
//    fileprivate var firstname: String?
//    fileprivate var lastname: String?
//    fileprivate var location: String?
//    fileprivate var emailAddress: String?
//    fileprivate var phoneNuber: String?
//    fileprivate var gender: String?
//    fileprivate var occupation: String?
//    fileprivate var linkedInProfile: String?
//    fileprivate var details: String?
    
    fileprivate var allDetailsDictionary: [String: Any]?
    
    static let sharedInstance = ProfileDetails()
    
    override init() {
        super.init()
        
        allDetailsDictionary?.updateValue("", forKey: "initialValue")
        
    }

    func setProfileDetails(profileDictionary: [String: Any]) {
                
//        if let url          = profileDictionary["imageUrl"]   as? String { self.imageUrl = url }
//        if let userName     = profileDictionary["username"]   as? String { self.username = userName }
//        if let firstName    = profileDictionary["firstName"]  as? String { self.firstname = firstName }
//        if let lastName     = profileDictionary["lastName"]   as? String { self.lastname = lastName }
//        if let loc          = profileDictionary["location"]   as? String { self.location = loc }
//        if let email        = profileDictionary["email"]      as? String { self.emailAddress = email }
//        if let phone        = profileDictionary["phone"]      as? String { self.phoneNuber = phone }
//        if let gender       = profileDictionary["gender"]     as? String { self.gender = gender }
//        if let occupation   = profileDictionary["occupation"] as? String { self.occupation = occupation }
//        if let linkedIn     = profileDictionary["linkedIn"]   as? String { self.linkedInProfile = linkedIn }
//        if let details      = profileDictionary["details"]    as? String { self.details = details }
        
        allDetailsDictionary = profileDictionary
        print(allDetailsDictionary ?? "")
    }
    func getProfileDetails() -> [String: Any]? {
        return allDetailsDictionary
    }
}

class ProfileBasic: NSObject {
    var username: String?
    var name: String?
    var city: String?
    var profileImageUrl: String?
    var gender: String?
}
