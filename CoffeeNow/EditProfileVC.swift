//
//  EditProfileVC.swift
//  CoffeeNow
//
//  Created by admin on 12/10/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class EditProfileVC: UIViewController, UITextFieldDelegate {
    
    var profileAnno: UserAnnotation?
    
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
    
    func testFunction () {
        print("Showing Test Function")
    }
    
    let profileName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Name:   "
        return label
    }()
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "City:   "
        return label
    }()
    let locationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "City Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Title:   "
        return label
    }()
    
    let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Title"
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
    
    let profileDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Profile Details: "
        return label
    }()
    let aboutMeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "About Me"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Email Address"
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
        label.text = "Phone Number"
        return label
    }()
    let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "000-000-0000"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let website: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Website URL"
        return label
    }()
    let websiteTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "website URL"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImageView)))
        editImageBtn.addTarget(self, action: #selector(selectProfileImageView), for: .touchUpInside)
        
        // Grab current profile info
        getUserDetails()

        
 //       guard let profileTitle = profileAnno?.title, let profileImageUrl = profileAnno?.imageUrl else { return }
        
//        self.navigationItem.title = profileTitle
//        self.profileName.text = profileTitle
//        imageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        genderTextField.delegate = self
        locationTextField.delegate = self
        titleTextField.delegate = self
        aboutMeTextField.delegate = self
        websiteTextField.delegate = self
        
        setupProfileViews()
    }
    
    func getUserDetails() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, first_name, email, picture, about, gender, location"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to state graph request", err ?? "")
                return
            }
            print("RESULTS!!! ", result)
        }
    }
    
    func setupProfileViews() {
        
        view.addSubview(profileImageView)
        view.addSubview(editImageBtn)
        view.addSubview(profileName)
        view.addSubview(nameTextField)
        view.addSubview(locationLabel)
        view.addSubview(locationTextField)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(profileDescription)
        view.addSubview(aboutMeTextField)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(phoneLabel)
        view.addSubview(phoneTextField)
        view.addSubview(website)
        view.addSubview(websiteTextField)
        view.addSubview(genderLabel)
        view.addSubview(genderTextField)
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        editImageBtn.rightAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        editImageBtn.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -10).isActive = true
        editImageBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        editImageBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        profileName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        profileName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        profileName.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        nameTextField.leftAnchor.constraint(equalTo: profileName.rightAnchor, constant: 10).isActive = true
        nameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        locationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        locationLabel.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 5).isActive = true
        locationLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        locationTextField.leftAnchor.constraint(equalTo: locationLabel.rightAnchor, constant: 10).isActive = true
        locationTextField.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 5).isActive = true
        locationTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        locationTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleTextField.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 10).isActive = true
        titleTextField.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        titleTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        profileDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        profileDescription.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        profileDescription.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileDescription.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        aboutMeTextField.leftAnchor.constraint(equalTo: profileDescription.rightAnchor, constant: 10).isActive = true
        aboutMeTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10).isActive = true
        aboutMeTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        aboutMeTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        emailLabel.topAnchor.constraint(equalTo: profileDescription.bottomAnchor, constant: 10).isActive = true
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
        
        website.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        website.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 10).isActive = true
        website.widthAnchor.constraint(equalToConstant: 120).isActive = true
        website.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        websiteTextField.leftAnchor.constraint(equalTo: website.rightAnchor, constant: 10).isActive = true
        websiteTextField.topAnchor.constraint(equalTo: website.topAnchor).isActive = true
        websiteTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        websiteTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        titleTextField.resignFirstResponder()
        aboutMeTextField.resignFirstResponder()
        websiteTextField.resignFirstResponder()
    }
}

