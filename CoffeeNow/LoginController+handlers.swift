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
                    
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                    }
                    
                })
            }
        })
    }
    
    func registerFacebook(user: FIRUser) {
        
        let profileImageUrl = user.photoURL?.absoluteString
        guard let image = profileImageUrl as String! else { return }
        print("Register Facebook ProfileImageUrl = ", image)
        
        getUserDetails { (userDetailsOutput) in
            
            guard let userName = userDetailsOutput["firstName"], let email = userDetailsOutput["email"], let imageUrl = userDetailsOutput["imageUrl"] else {
                return
            }
            let values = ["name": userName, "email": email, "profileImageUrl": imageUrl]
            self.registerUserIntoDatabaseWithUID(uid: user.uid, values: values)
        }
    }
    
    func getUserDetails(completion: @escaping ([String: Any]) -> ()) {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, first_name, last_name, email, picture, about, gender, location"]).start { (connection, result, err) in
            
            var userDetails = [String: Any]()
            
            if err != nil {
                print("Failed to state graph request", err ?? "")
                return
            }
            print("RESULTS!!! ", result ?? "")
            
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
            self.messageController?.navigationItem.title = values["name"] as? String
            self.dismiss(animated: true, completion: nil)
        })
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
