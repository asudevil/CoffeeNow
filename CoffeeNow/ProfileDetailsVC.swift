//
//  ProfileDetailsVC.swift
//  CoffeeNow
//
//  Created by admin on 12/8/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class ProfileDetailsVC: UIViewController {
    
    var profileAnno: UserAnnotation?
    
    let imageContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor(r: 223, g: 233, b: 238, a: 1)
        return container
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.gray
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let profileName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.layer.masksToBounds = true
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Location Label"
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Title Label"
        return label
    }()
    
    let profileDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Description Label"
        return label
    }()
    
    let requestContactBtn: UIButton = {
        let addBtn = UIButton()
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.backgroundColor = UIColor.white
        addBtn.layer.masksToBounds = true
        addBtn.contentMode = .scaleAspectFill
        addBtn.setImage(UIImage(named: "addUser"), for: .normal)
        return addBtn
    }()
    
    let requestUserLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Request contact info"
        return label
    }()
    
    let saveUserToContactsBtn: UIButton = {
        let saveBtn = UIButton()
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.backgroundColor = UIColor.white
        saveBtn.layer.masksToBounds = true
        saveBtn.contentMode = .scaleAspectFill
        saveBtn.setImage(UIImage(named: "account"), for: .normal)
        saveBtn.addTarget(self, action: #selector(saveUserToContacts), for: .touchUpInside)
        return saveBtn
    }()
    
    let saveUserToContactsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Save user info to contacts"
        return label
    }()
    
    let shareProfileInfoBtn: UIButton = {
        let blockBtn = UIButton()
        blockBtn.translatesAutoresizingMaskIntoConstraints = false
        blockBtn.backgroundColor = UIColor.white
        blockBtn.layer.masksToBounds = true
        blockBtn.contentMode = .scaleAspectFill
        blockBtn.setImage(UIImage(named: "contacts"), for: .normal)
        return blockBtn
    }()
    
    let shareProfileInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Share my contact info with user"
        return label
    }()
    
    let blockContactBtn: UIButton = {
        let blockBtn = UIButton()
        blockBtn.translatesAutoresizingMaskIntoConstraints = false
        blockBtn.backgroundColor = UIColor.white
        blockBtn.layer.masksToBounds = true
        blockBtn.contentMode = .scaleAspectFill
        blockBtn.setImage(UIImage(named: "blockImage"), for: .normal)
        return blockBtn
    }()
    
    let blockUserLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Block User"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        guard let profileTitle = profileAnno?.title, let profileImageUrl = profileAnno?.imageUrl else { return }
        
        self.navigationItem.title = profileTitle
        self.profileName.text = profileTitle
        imageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        
        setupProfileViews()
    }
    
    func saveUserToContacts() {
        print("Save User to Contacts Clicked")
    }
    
    func setupProfileViews() {
        
        view.addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        imageContainer.addSubview(profileName)
        imageContainer.addSubview(locationLabel)
        view.addSubview(titleLabel)
        view.addSubview(profileDescription)
        view.addSubview(requestContactBtn)
        view.addSubview(requestUserLabel)
        view.addSubview(saveUserToContactsBtn)
        view.addSubview(saveUserToContactsLabel)
        view.addSubview(shareProfileInfoBtn)
        view.addSubview(shareProfileInfoLabel)
        view.addSubview(blockContactBtn)
        view.addSubview(blockUserLabel)

        //x, y, width and height constraints
        imageContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageContainer.heightAnchor.constraint(equalToConstant: 310).isActive = true
        
        imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        profileName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 5).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        profileDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileDescription.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        profileDescription.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        requestContactBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        requestContactBtn.topAnchor.constraint(equalTo: profileDescription.bottomAnchor, constant: 20).isActive = true
        requestContactBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        requestContactBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        requestUserLabel.leftAnchor.constraint(equalTo: requestContactBtn.rightAnchor, constant: 5).isActive = true
        requestUserLabel.topAnchor.constraint(equalTo: profileDescription.bottomAnchor, constant: 20).isActive = true
        requestUserLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        requestUserLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        saveUserToContactsBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        saveUserToContactsBtn.topAnchor.constraint(equalTo: requestUserLabel.bottomAnchor, constant: 20).isActive = true
        saveUserToContactsBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        saveUserToContactsBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        saveUserToContactsLabel.leftAnchor.constraint(equalTo: saveUserToContactsBtn.rightAnchor, constant: 5).isActive = true
        saveUserToContactsLabel.topAnchor.constraint(equalTo: requestUserLabel.bottomAnchor, constant: 20).isActive = true
        saveUserToContactsLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        saveUserToContactsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        shareProfileInfoBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        shareProfileInfoBtn.topAnchor.constraint(equalTo: saveUserToContactsBtn.bottomAnchor, constant: 20).isActive = true
        shareProfileInfoBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        shareProfileInfoBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        shareProfileInfoLabel.leftAnchor.constraint(equalTo: shareProfileInfoBtn.rightAnchor, constant: 5).isActive = true
        shareProfileInfoLabel.topAnchor.constraint(equalTo: saveUserToContactsBtn.bottomAnchor, constant: 20).isActive = true
        shareProfileInfoLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        shareProfileInfoLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        blockContactBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        blockContactBtn.topAnchor.constraint(equalTo: shareProfileInfoBtn.bottomAnchor, constant: 20).isActive = true
        blockContactBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        blockContactBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        blockUserLabel.leftAnchor.constraint(equalTo: blockContactBtn.rightAnchor, constant: 5).isActive = true
        blockUserLabel.topAnchor.constraint(equalTo: shareProfileInfoBtn.bottomAnchor, constant: 20).isActive = true
        blockUserLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        blockUserLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
