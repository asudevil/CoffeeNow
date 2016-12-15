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
    
    let addContactBtn: UIButton = {
        let addBtn = UIButton()
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.backgroundColor = UIColor.white
        addBtn.layer.masksToBounds = true
        addBtn.contentMode = .scaleAspectFill
        addBtn.setImage(UIImage(named: "addUser"), for: .normal)
        return addBtn
    }()
    
    let addUserLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Request contact info"
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
    
    func setupProfileViews() {
        
        view.addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        imageContainer.addSubview(profileName)
        imageContainer.addSubview(locationLabel)
        view.addSubview(titleLabel)
        view.addSubview(profileDescription)
        view.addSubview(addUserLabel)
        view.addSubview(addContactBtn)
        view.addSubview(blockContactBtn)
        view.addSubview(blockUserLabel)

        //x, y, width and height constraints
        imageContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageContainer.heightAnchor.constraint(equalToConstant: 330).isActive = true
        
        imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        profileName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 5).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 30).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        profileDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileDescription.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        profileDescription.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addContactBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        addContactBtn.topAnchor.constraint(equalTo: profileDescription.bottomAnchor, constant: 20).isActive = true
        addContactBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addContactBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addUserLabel.leftAnchor.constraint(equalTo: blockContactBtn.rightAnchor, constant: 5).isActive = true
        addUserLabel.topAnchor.constraint(equalTo: profileDescription.bottomAnchor, constant: 20).isActive = true
        addUserLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        addUserLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        blockContactBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        blockContactBtn.topAnchor.constraint(equalTo: addContactBtn.bottomAnchor, constant: 20).isActive = true
        blockContactBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        blockContactBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        blockUserLabel.leftAnchor.constraint(equalTo: blockContactBtn.rightAnchor, constant: 5).isActive = true
        blockUserLabel.topAnchor.constraint(equalTo: addUserLabel.bottomAnchor, constant: 20).isActive = true
        blockUserLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        blockUserLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
