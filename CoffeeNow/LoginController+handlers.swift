//
//  LoginController+handlers.swift
//  CoffeeNow
//
//  Created by admin on 10/29/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            //Successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        //Basic Info
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                        
                        //Detail Info
                        let userDetails = ["userName": name, "email": email, "imageUrl": profileImageUrl, "firstName": "", "lastName": "", "location": "", "gender": "", "phone":"", "occupation":"", "LinkedIn":"", "details":""]
                        self.addUserDetailsIntoDataBaseWithUID(uid: uid, values: userDetails)
                        ProfileDetails.sharedInstance.setProfileDetails(profileDictionary: userDetails)
                    }
                })
            } else {
                //Basic Info
                let values = ["name": name, "email": email, "profileImageUrl": ""]
                self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                //Detail Info
                let userDetails = ["userName": name, "email": email, "imageUrl": "", "firstName": "", "lastName": "", "location": "", "gender": "", "phone":"", "occupation":"", "LinkedIn":"", "details":""]
                self.addUserDetailsIntoDataBaseWithUID(uid: uid, values: userDetails)
                ProfileDetails.sharedInstance.setProfileDetails(profileDictionary: userDetails)
            }
        })
    }
    
    func registerFacebook(user: FIRUser) {
        
        let profileImageUrl = user.photoURL?.absoluteString
        guard let image = profileImageUrl as String! else { return }
        print("Register Facebook ProfileImageUrl = ", image)
        
        getFBUserDetails { (userDetailsOutput) in
            
            guard let userName = userDetailsOutput["firstName"], let email = userDetailsOutput["email"], let imageUrl = userDetailsOutput["imageUrl"] else {
                return
            }
            //basic info
            let values = ["name": userName, "email": email, "profileImageUrl": imageUrl]
            self.registerUserIntoDatabaseWithUID(uid: user.uid, values: values)
            
            //Detail Info
            var dbInfo = [String: Any]()
            if let fbImageUrl   = userDetailsOutput["imageUrl"] as? String { dbInfo.updateValue(fbImageUrl, forKey: "imageUrl")
            } else { dbInfo.updateValue("", forKey: "imageUrl") }
            if let fbUserName   = userDetailsOutput["userName"] as? String { dbInfo.updateValue(fbUserName, forKey: "userName")
            } else { dbInfo.updateValue("", forKey: "userName") }
            if let fbFirstName  = userDetailsOutput["firstName"] as? String { dbInfo.updateValue(fbFirstName, forKey: "firstName")
            } else { dbInfo.updateValue("", forKey: "firstName") }
            if let fbLastName   = userDetailsOutput["lastName"] as? String { dbInfo.updateValue(fbLastName, forKey: "lastName")
            } else { dbInfo.updateValue("", forKey: "lastName") }
            if let fbLocation   = userDetailsOutput["location"] as? String { dbInfo.updateValue(fbLocation, forKey: "location")
            } else { dbInfo.updateValue("", forKey: "location")}
            if let fbEmail      = userDetailsOutput["email"] as? String { dbInfo.updateValue(fbEmail, forKey: "email")
            } else { dbInfo.updateValue("", forKey: "email") }
            if let fbPhone      = userDetailsOutput["phone"] as? String { dbInfo.updateValue(fbPhone, forKey: "phone")
            } else { dbInfo.updateValue("", forKey: "phone") }
            if let fbGender     = userDetailsOutput["gender"] as? String { dbInfo.updateValue(fbGender, forKey: "gender")
            } else { dbInfo.updateValue("", forKey: "gender") }
            if let fbOccupation = userDetailsOutput["occupation"] as? String { dbInfo.updateValue(fbOccupation, forKey: "occupation")
            } else {dbInfo.updateValue("", forKey: "occupation")}
            if let fbLinkedIn   = userDetailsOutput["linkedIn"] as? String { dbInfo.updateValue(fbLinkedIn, forKey: "linkedIn")
            } else {dbInfo.updateValue("", forKey: "linkedIn") }
            if let fbDetails    = userDetailsOutput["details"] as? String { dbInfo.updateValue(fbDetails, forKey: "details")
            } else {dbInfo.updateValue("", forKey: "details")}
            self.addUserDetailsIntoDataBaseWithUID(uid: user.uid, values: dbInfo)
        }
    }
    
    func getFBUserDetails(completion: @escaping ([String: Any]) -> ()) {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, first_name, last_name, email, picture, about, gender, location"]).start { (connection, result, err) in
            if err != nil {
                print("Failed to state graph request", err ?? "")
                return
            }
            var userDetails = [String: Any]()
            if let resultDictionary = result as? [String: Any] {
                if let username = resultDictionary["first_name"] as? String {
                    userDetails.updateValue(username, forKey: "userName")
                }
                if let firstName = resultDictionary["first_name"] as? String {
                    userDetails.updateValue(firstName, forKey: "firstName")
                }
                if let lastName = resultDictionary["last_name"] as? String {
                    userDetails.updateValue(lastName, forKey: "lastName")
                }
                if let location = resultDictionary["location"] as? String {
                    userDetails.updateValue(location, forKey: "location")
                }
                if let email = resultDictionary["email"] as? String {
                    userDetails.updateValue(email, forKey: "email")
                }
                if let gender = resultDictionary["gender"] as? String {
                    userDetails.updateValue(gender, forKey: "gender")
                }
                if let picture = resultDictionary["picture"] as? [String: Any] {
                    if let data = picture["data"] as? [String: Any] {
                        if let profileImgUrl = data["url"] as? String {
                            userDetails.updateValue(profileImgUrl, forKey: "imageUrl")
                        }
                    }
                }
            }
            completion(userDetails)
            
            ProfileDetails.sharedInstance.setProfileDetails(profileDictionary: userDetails)
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            self.mainVC?.navigationItem.title = values["name"] as? String
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    private func addUserDetailsIntoDataBaseWithUID(uid: String, values: [String: Any]) {
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users-details").child(uid)
        userReference.updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        }
    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled Picker")
        dismiss(animated: true, completion: nil)
    }
}
extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a:CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
