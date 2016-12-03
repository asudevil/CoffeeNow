//
//  LoginController+handlers.swift
//  CoffeeNow
//
//  Created by admin on 10/29/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase

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
        
        let profileImageUrl = "https://firebasestorage.googleapis.com/v0/b/coffeenow-1bc87.appspot.com/o/profile_images%2F9B403AA9-19CE-4670-AEA3-D5E006A791F6.jpg?alt=media&token=ff652448-25c8-40fb-a61a-ee88078e9f62"
        
        let values = ["name": user.displayName, "email": user.email, "profileImageUrl": profileImageUrl]
        self.registerUserIntoDatabaseWithUID(uid: user.uid, values: values)
        
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            
    //        self.messageController?.fetchUserAndSetupNavBarTitle()
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
