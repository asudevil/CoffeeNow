//
//  EditProfileVC.swift
//  CoffeeNow
//
//  Created by admin on 12/10/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class EditProfileVC: UIViewController, UITextFieldDelegate {
    
    var profileAnno: UserAnnotation?
    
    var profileImageUrl: String?
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.gray
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "profileImage")
        return imageView
    }()
    
    let editImageBtn: UIButton = {
        let editBtn = UIButton()
        editBtn.translatesAutoresizingMaskIntoConstraints = false
        editBtn.backgroundColor = UIColor.white
        editBtn.layer.masksToBounds = true
        editBtn.contentMode = .scaleAspectFill
        editBtn.setImage(UIImage(named: "editIcon"), for: .normal)
        return editBtn
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Username:   "
        return label
    }()
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    let firstName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "First Name:   "
        return label
    }()
    let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "First Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    
    let lastName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Last Name:   "
        return label
    }()
    
    let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    let genderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Gender: "
        return label
    }()
    let genderTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Male or Female"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    
    let location: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Location: "
        return label
    }()
    let locationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "City or Town"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Email Address:"
        return label
    }()
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Phone Number:"
        return label
    }()
    let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "000-000-0000"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let occupation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Occupation:"
        return label
    }()
    let occupationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Occupation"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let linkedIn: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "LinkedIn:  "
        return label
    }()
    let linkedInTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "LinkedIn URL"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let profileInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Profile Details: "
        return label
    }()
    let profileInfoTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Keywords describing you?"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveButton))
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImageView)))
        editImageBtn.addTarget(self, action: #selector(selectProfileImageView), for: .touchUpInside)
        
        // Grab current profile info
        getUserDetails()
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        genderTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        locationTextField.delegate = self
        occupationTextField.delegate = self
        linkedInTextField.delegate = self
        profileInfoTextField.delegate = self
        
        setupProfileViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        getUserDetails()
    }
    func getUserDetails() {
        
        let saveDetails = ProfileDetails.sharedInstance.getProfileDetails()
        
        if let email        = saveDetails?["email"]      as? String { self.emailTextField.text = email }
        if let userName     = saveDetails?["userName"]  as? String { self.usernameTextField.text = userName }
        if let firstName    = saveDetails?["firstName"]  as? String { self.firstNameTextField.text = firstName }
        if let lastName     = saveDetails?["lastName"]   as? String { self.lastNameTextField.text = lastName }
        if let gender       = saveDetails?["gender"]     as? String { self.genderTextField.text = gender }
        if let loc          = saveDetails?["location"]   as? String { self.locationTextField.text = loc }
        if let phone        = saveDetails?["phone"]      as? String { self.phoneTextField.text = phone }
        if let title        = saveDetails?["occupation"] as? String { self.genderTextField.text = title }
        if let LN           = saveDetails?["linkedIn"]   as? String { self.genderTextField.text = LN }
        if let details      = saveDetails?["details"]    as? String { self.genderTextField.text = details }
        if let imgUrl       = saveDetails?["imageUrl"]   as? String {
            self.profileImageView.loadImageUsingCacheWithUrlString(urlString: imgUrl)
        }
    }

    func cancelButton() {
        navigationController?.popViewController(animated: true)
    }
    func saveButton() {
        print("Save Button clicked!!")
        updatedProfileText(fieldToUpdate: "imageUrl", newInfo: self.profileImageUrl)
        updatedProfileText(fieldToUpdate: "userName", newInfo: usernameTextField.text)
        updatedProfileText(fieldToUpdate: "firstName", newInfo: firstNameTextField.text)
        updatedProfileText(fieldToUpdate: "lastName", newInfo: lastNameTextField.text)
        updatedProfileText(fieldToUpdate: "location", newInfo: locationTextField.text)
        updatedProfileText(fieldToUpdate: "email", newInfo: emailTextField.text)
        updatedProfileText(fieldToUpdate: "phone", newInfo: phoneTextField.text)
        updatedProfileText(fieldToUpdate: "gender", newInfo: genderTextField.text)
        updatedProfileText(fieldToUpdate: "occupation", newInfo: occupationTextField.text)
        updatedProfileText(fieldToUpdate: "linkedIn", newInfo: linkedInTextField.text)
        updatedProfileText(fieldToUpdate: "details", newInfo: profileInfoTextField.text)
    }
    
    func updatedProfileText(fieldToUpdate: String, newInfo: String?) {
        
        var profileDetailsDic = ProfileDetails.sharedInstance.getProfileDetails()
        
        if let user = profileDetailsDic?[fieldToUpdate] as? String {
            if user == newInfo {
                print("No changes")
            } else {
                profileDetailsDic?.updateValue(newInfo, forKey: fieldToUpdate)
                ProfileDetails.sharedInstance.setProfileDetails(profileDictionary: profileDetailsDic!)
                print("Setting ProfileDetails to:", ProfileDetails.sharedInstance.getProfileDetails() ?? "")
            }
        }
    }
    
    func setupProfileViews() {
        
        view.addSubview(profileImageView)
        view.addSubview(editImageBtn)
        view.addSubview(userName)
        view.addSubview(usernameTextField)
        view.addSubview(firstName)
        view.addSubview(firstNameTextField)
        view.addSubview(lastName)
        view.addSubview(lastNameTextField)
        view.addSubview(location)
        view.addSubview(locationTextField)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(phoneLabel)
        view.addSubview(phoneTextField)
        view.addSubview(genderLabel)
        view.addSubview(genderTextField)
        view.addSubview(occupation)
        view.addSubview(occupationTextField)
        view.addSubview(linkedIn)
        view.addSubview(linkedInTextField)
        view.addSubview(profileInfo)
        view.addSubview(profileInfoTextField)
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        editImageBtn.rightAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        editImageBtn.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -10).isActive = true
        editImageBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        editImageBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        userName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        userName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        userName.widthAnchor.constraint(equalToConstant: 120).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        usernameTextField.leftAnchor.constraint(equalTo: userName.rightAnchor, constant: 10).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        usernameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        firstName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        firstName.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 5).isActive = true
        firstName.widthAnchor.constraint(equalToConstant: 120).isActive = true
        firstName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        firstNameTextField.leftAnchor.constraint(equalTo: firstName.rightAnchor, constant: 10).isActive = true
        firstNameTextField.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 5).isActive = true
        firstNameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        firstNameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        lastName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        lastName.topAnchor.constraint(equalTo: firstName.bottomAnchor, constant: 10).isActive = true
        lastName.widthAnchor.constraint(equalToConstant: 120).isActive = true
        lastName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        lastNameTextField.leftAnchor.constraint(equalTo: lastName.rightAnchor, constant: 10).isActive = true
        lastNameTextField.topAnchor.constraint(equalTo: lastName.topAnchor).isActive = true
        lastNameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        lastNameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        location.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        location.topAnchor.constraint(equalTo: lastName.bottomAnchor, constant: 10).isActive = true
        location.widthAnchor.constraint(equalToConstant: 120).isActive = true
        location.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        locationTextField.leftAnchor.constraint(equalTo: location.rightAnchor, constant: 10).isActive = true
        locationTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 10).isActive = true
        locationTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        locationTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        emailLabel.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: emailLabel.rightAnchor, constant: 10).isActive = true
        emailTextField.topAnchor.constraint(equalTo: emailLabel.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        phoneLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10).isActive = true
        phoneLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        phoneTextField.leftAnchor.constraint(equalTo: phoneLabel.rightAnchor, constant: 10).isActive = true
        phoneTextField.topAnchor.constraint(equalTo: phoneLabel.topAnchor).isActive = true
        phoneTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        genderLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        genderLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 10).isActive = true
        genderLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        genderLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        genderTextField.leftAnchor.constraint(equalTo: genderLabel.rightAnchor, constant: 10).isActive = true
        genderTextField.topAnchor.constraint(equalTo: genderLabel.topAnchor).isActive = true
        genderTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        genderTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        occupation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        occupation.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 10).isActive = true
        occupation.widthAnchor.constraint(equalToConstant: 120).isActive = true
        occupation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        occupationTextField.leftAnchor.constraint(equalTo: occupation.rightAnchor, constant: 10).isActive = true
        occupationTextField.topAnchor.constraint(equalTo: occupation.topAnchor).isActive = true
        occupationTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        occupationTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        linkedIn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        linkedIn.topAnchor.constraint(equalTo: occupation.bottomAnchor, constant: 10).isActive = true
        linkedIn.widthAnchor.constraint(equalToConstant: 120).isActive = true
        linkedIn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        linkedInTextField.leftAnchor.constraint(equalTo: linkedIn.rightAnchor, constant: 10).isActive = true
        linkedInTextField.topAnchor.constraint(equalTo: linkedIn.topAnchor).isActive = true
        linkedInTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        linkedInTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        profileInfo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        profileInfo.topAnchor.constraint(equalTo: linkedIn.bottomAnchor, constant: 10).isActive = true
        profileInfo.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        profileInfoTextField.leftAnchor.constraint(equalTo: profileInfo.rightAnchor, constant: 10).isActive = true
        profileInfoTextField.topAnchor.constraint(equalTo: profileInfo.topAnchor).isActive = true
        profileInfoTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileInfoTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        occupationTextField.resignFirstResponder()
        linkedInTextField.resignFirstResponder()
        profileInfoTextField.resignFirstResponder()
    }
}

