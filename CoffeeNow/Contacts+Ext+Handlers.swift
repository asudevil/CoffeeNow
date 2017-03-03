//
//  ContactsHandlers.swift
//  CoffeeNow
//
//  Created by admin on 12/30/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Contacts
import Firebase

extension UserProfileCollectionVC {
    
    func addContact(contactInfoToSave: [String: Any]) {
        switch CNContactStore.authorizationStatus(for: .contacts){
        case .authorized:
                print("Authorized")
              saveContact(contactInfo: contactInfoToSave)
        case .notDetermined:
            print("notDetermined")
            store.requestAccess(for: .contacts){succeeded, err in
                guard err == nil && succeeded else{
                    return
                }
                self.saveContact(contactInfo: contactInfoToSave)
            }
        default:
            print("Not handled")
        }
    }

    func saveContact(contactInfo: [String: Any]) {
        
        let contact = CNMutableContact()
        
        if let firstName = contactInfo["firstName"] as? String {
            contact.givenName = firstName
        }

        if let lastName = contactInfo["lastName"] as? String {
            contact.familyName = lastName
        }

        if let imgUrl = contactInfo["imageUrl"] as? String {
            let imgView = UIImageView()
            imgView.loadImageUsingCacheWithUrlString(urlString: imgUrl)
            if let img = imgView.image,
                let imgData = UIImagePNGRepresentation(img){
                contact.imageData = imgData
            }
        }

        if let email = contactInfo["email"] as? String {
            let email = email as NSString
            let homeEmail = CNLabeledValue(label: CNLabelHome, value: email)
            contact.emailAddresses = [homeEmail]
        }

        if let phone = contactInfo["phone"] as? String {
            contact.phoneNumbers = [CNLabeledValue(label:CNLabelPhoneNumberiPhone, value:CNPhoneNumber(stringValue:phone))]
        }

        if let notes = contactInfo["details"] as? String {
            contact.note = notes
        }

        //Social Media Profiles:
        if let linkedInUserName = contactInfo["linkedIn"] as? String {
            let linkedInProfile = CNLabeledValue(label: "LinkedIn", value: CNSocialProfile(urlString: nil, username: linkedInUserName, userIdentifier: nil, service: CNSocialProfileServiceLinkedIn))
        
            contact.socialProfiles = [linkedInProfile]   // [facebookProfile, twitterProfile, linkedInProfile]
        }
        
        if let jobTitle = contactInfo["occupation"] as? String {
            contact.jobTitle = jobTitle
        }
        let request = CNSaveRequest()

        request.add(contact, toContainerWithIdentifier: nil)
        
        do{
            try store.execute(request)
            let alertTitle = "Contact Added!"
            let alertMsg = "Successfully added the contact to your iPhone contacts.  Please check your iphone contacts to verify"
            self.alertTaskComplete(taskTitle: alertTitle, confirmation: alertMsg)
            
        } catch let err{
            let alertTitle = "ERROR ADDING CONTACT"
            let alertMsg = "Failed to save the contact.  Please check the information and try again"
            self.alertTaskComplete(taskTitle: alertTitle, confirmation: alertMsg)
            print(alertTitle, err)
        }
    }
    func handleShareRequests(requestType: String, success: @escaping (Bool) -> ()) {
        
        guard let toId = contactId else {return }
        let fromId = FIRAuth.auth()!.currentUser!.uid
        
        let refId = fromId + toId
        
        let ref = FIRDatabase.database().reference().child("contacts-permissions")
        let childRef = ref.child(refId)
        
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = [requestType: "Yes", "toID": toId, "fromID": fromId, "timestamp": timestamp] as [String : Any]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            } else {
                success(true)
            }
        }
        
        let userRequestsRef = FIRDatabase.database().reference().child("contact-requests/\(toId)/\(fromId)")
        userRequestsRef.child("timestamp").setValue(timestamp)
        userRequestsRef.child("requestAddress").setValue("Unknown Location")
        
        let location = CLLocation(latitude: contactLocation.latitude, longitude: contactLocation.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            guard let placemarks = placemarks else {
                print("Reverse geocoder returned 0 placemarks")
                return
            }
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0]
                var requestAddress = ""
                if let subThoroughfare = pm.subThoroughfare { requestAddress.append("\(subThoroughfare) ") }
                if let thoroughfare = pm.thoroughfare { requestAddress.append("\(thoroughfare), ") }
                if let locality = pm.locality { requestAddress.append(locality) }
                
                if requestAddress == "" {
                    return
                } else {
                    userRequestsRef.child("requestAddress").setValue(requestAddress)
                }
            }
        })
        
        
        
    }
}
