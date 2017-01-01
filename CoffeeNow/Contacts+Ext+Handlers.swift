//
//  ContactsHandlers.swift
//  CoffeeNow
//
//  Created by admin on 12/30/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Contacts

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

        var contact = CNMutableContact()
        let request = CNSaveRequest()
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactNoteKey, CNContactSocialProfilesKey, CNContactJobTitleKey]
        
        var givenName = String()
        var familyName = String()
        var phone = "Not Available"
        if let firstName = contactInfo["firstName"] as? String {
            givenName = firstName
        }
        if let lastName = contactInfo["lastName"] as? String {
            familyName = lastName
        }
        if let phoneNumber = contactInfo["phone"] as? String {
            phone = phoneNumber
        }
        
//        let predicate = CNContact.predicateForContacts(matchingName: "\(givenName) \(familyName)")
        let predicate2 = CNContact.predicateForContacts(withIdentifiers: [givenName, familyName, phone])
        
        do {
            let contacts = try store.unifiedContacts(matching: predicate2, keysToFetch: keysToFetch as [CNKeyDescriptor])
            print("Contacts fetched.", contacts.count)
            if let output = contacts.first {
                contact = output.mutableCopy() as! CNMutableContact
                createContact(contactInfoToCreate: contactInfo, cnContact: contact)
                request.update(contact)
                print("User already exists so updating contact info")
            } else {
                createContact(contactInfoToCreate: contactInfo, cnContact: contact)
                request.add(contact, toContainerWithIdentifier: nil)
                print("Adding new contact to list!")
            }
        }
        catch {
            print("Unable to fetch contacts.")
        }
        
        do{
            try store.execute(request)
            print("Successfully added or updated the contact")
        } catch let err{
            print("Failed to save the contact. \(err)")
        }
    }

    func createContact(contactInfoToCreate: [String: Any], cnContact: CNMutableContact) {
        
        if let firstName = contactInfoToCreate["firstName"] as? String {
            cnContact.givenName = firstName
        }

        if let lastName = contactInfoToCreate["lastName"] as? String {
            cnContact.familyName = lastName
        }

        if let imgUrl = contactInfoToCreate["imageUrl"] as? String {
            let imgView = UIImageView()
            imgView.loadImageUsingCacheWithUrlString(urlString: imgUrl)
            if let img = imgView.image,
                let imgData = UIImagePNGRepresentation(img){
                cnContact.imageData = imgData
            }
        }

        if let email = contactInfoToCreate["email"] as? String {
            let email = email as NSString
            let homeEmail = CNLabeledValue(label: CNLabelHome, value: email)
            cnContact.emailAddresses = [homeEmail]
        }

        if let phone = contactInfoToCreate["phone"] as? String {
            cnContact.phoneNumbers = [CNLabeledValue(label:CNLabelPhoneNumberiPhone, value:CNPhoneNumber(stringValue:phone))]
        }

        if let notes = contactInfoToCreate["details"] as? String {
            cnContact.note = notes
        }

        //Social Media Profiles:
        if let linkedInUserName = contactInfoToCreate["linkedIn"] as? String {
            let linkedInProfile = CNLabeledValue(label: "LinkedIn", value: CNSocialProfile(urlString: nil, username: linkedInUserName, userIdentifier: nil, service: CNSocialProfileServiceLinkedIn))
        
            cnContact.socialProfiles = [linkedInProfile]   // [facebookProfile, twitterProfile, linkedInProfile]
        }
        
        if let jobTitle = contactInfoToCreate["occupation"] as? String {
            cnContact.jobTitle = jobTitle
        }
    }
}
