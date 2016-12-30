//
//  UserHeaderCell.swift
//  CoffeeNow
//
//  Created by admin on 12/29/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class UserHeaderCell: UICollectionViewCell {
    
    
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

    let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "FirstName LastName"
        return label
    }()
    let messageBtn: UIButton = {
        let msgBtn = UIButton()
        msgBtn.translatesAutoresizingMaskIntoConstraints = false
        msgBtn.backgroundColor = UIColor.white
        msgBtn.layer.masksToBounds = true
        msgBtn.contentMode = .scaleAspectFill
        msgBtn.setImage(UIImage(named: "chatBtn"), for: .normal)
        msgBtn.addTarget(self, action: #selector(tappedMessageBtn), for: .touchUpInside)
        return msgBtn
    }()
    let message: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "message"
        label.font = UIFont(name: "Helvetica Neue", size: 15)
        label.textAlignment = .center
        return label
    }()
    let requestContactBtn: UIButton = {
        let addBtn = UIButton()
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.backgroundColor = UIColor.white
        addBtn.layer.masksToBounds = true
        addBtn.contentMode = .scaleAspectFill
        addBtn.setImage(UIImage(named: "addUser"), for: .normal)
        addBtn.addTarget(self, action: #selector(requestUserInfoTapped), for: .touchUpInside)
        return addBtn
    }()
    
    let requestUserLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.font = UIFont(name: "Helvetica Neue", size: 15)
        label.textAlignment = .center
        label.text = "request"
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
        label.font = UIFont(name: "Helvetica Neue", size: 15)
        label.textAlignment = .center
        label.text = "save"
        return label
    }()
    
    let shareProfileInfoBtn: UIButton = {
        let shareBtn = UIButton()
        shareBtn.translatesAutoresizingMaskIntoConstraints = false
        shareBtn.backgroundColor = UIColor.white
        shareBtn.layer.masksToBounds = true
        shareBtn.contentMode = .scaleAspectFill
        shareBtn.setImage(UIImage(named: "contacts"), for: .normal)
        shareBtn.addTarget(self, action: #selector(shareUserTapped), for: .touchUpInside)

        return shareBtn
    }()
    
    let shareProfileInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.font = UIFont(name: "Helvetica Neue", size: 15)
        label.textAlignment = .center
        label.text = "share"
        return label
    }()
    
    let blockContactBtn: UIButton = {
        let blockBtn = UIButton()
        blockBtn.translatesAutoresizingMaskIntoConstraints = false
        blockBtn.backgroundColor = UIColor.white
        blockBtn.layer.masksToBounds = true
        blockBtn.contentMode = .scaleAspectFill
        blockBtn.setImage(UIImage(named: "blockImage"), for: .normal)
        blockBtn.addTarget(self, action: #selector(blockUserTapped), for: .touchUpInside)
        return blockBtn
    }()
    
    let blockUserLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.font = UIFont(name: "Helvetica Neue", size: 15)
        label.textAlignment = .center
        label.text = "block"
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        backgroundColor = UIColor(r: 223, g: 233, b: 238, a: 1)
        
        addSubview(profileImageView)
        addSubview(name)
        addSubview(messageBtn)
        addSubview(message)
        addSubview(requestContactBtn)
        addSubview(requestUserLabel)
        addSubview(saveUserToContactsBtn)
        addSubview(saveUserToContactsLabel)
        addSubview(shareProfileInfoBtn)
        addSubview(shareProfileInfoLabel)
        addSubview(blockContactBtn)
        addSubview(blockUserLabel)
        
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        name.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        name.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5).isActive = true
        name.heightAnchor.constraint(equalToConstant: 30).isActive = true
        name.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        messageBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        messageBtn.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10).isActive = true
        messageBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        messageBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        message.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        message.topAnchor.constraint(equalTo: messageBtn.bottomAnchor).isActive = true
        message.heightAnchor.constraint(equalToConstant: 20).isActive = true
        message.widthAnchor.constraint(equalToConstant: 62).isActive = true
        
        requestContactBtn.leftAnchor.constraint(equalTo: message.rightAnchor, constant: 20).isActive = true
        requestContactBtn.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10).isActive = true
        requestContactBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        requestContactBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        requestUserLabel.leftAnchor.constraint(equalTo: message.rightAnchor, constant: 10).isActive = true
        requestUserLabel.topAnchor.constraint(equalTo: requestContactBtn.bottomAnchor).isActive = true
        requestUserLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        requestUserLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        saveUserToContactsBtn.leftAnchor.constraint(equalTo: requestUserLabel.rightAnchor, constant: 30).isActive = true
        saveUserToContactsBtn.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10).isActive = true
        saveUserToContactsBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        saveUserToContactsBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        saveUserToContactsLabel.leftAnchor.constraint(equalTo: requestUserLabel.rightAnchor, constant: 20).isActive = true
        saveUserToContactsLabel.topAnchor.constraint(equalTo: saveUserToContactsBtn.bottomAnchor).isActive = true
        saveUserToContactsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        saveUserToContactsLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        shareProfileInfoBtn.leftAnchor.constraint(equalTo: saveUserToContactsLabel.rightAnchor, constant: 30).isActive = true
        shareProfileInfoBtn.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10).isActive = true
        shareProfileInfoBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        shareProfileInfoBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        shareProfileInfoLabel.leftAnchor.constraint(equalTo: saveUserToContactsLabel.rightAnchor, constant: 20).isActive = true
        shareProfileInfoLabel.topAnchor.constraint(equalTo: shareProfileInfoBtn.bottomAnchor).isActive = true
        shareProfileInfoLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        shareProfileInfoLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        blockContactBtn.leftAnchor.constraint(equalTo: shareProfileInfoLabel.rightAnchor, constant: 20).isActive = true
        blockContactBtn.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10).isActive = true
        blockContactBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        blockContactBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        blockUserLabel.leftAnchor.constraint(equalTo: shareProfileInfoLabel.rightAnchor, constant: 10).isActive = true
        blockUserLabel.topAnchor.constraint(equalTo: blockContactBtn.bottomAnchor).isActive = true
        blockUserLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        blockUserLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    ////////////// The functions do NOTHING.  They are placeholders for collectionViewCell.
    ////////////// Actual implementation take place in the collectionViewController UserProfileCollectionVC
    func saveUserToContacts(sender: UITapGestureRecognizer) { }
    func requestUserInfoTapped(sender: UITapGestureRecognizer) { }
    func tappedMessageBtn(sender: UITapGestureRecognizer) { }
    func shareUserTapped(sender: UITapGestureRecognizer) { }
    func blockUserTapped(sender: UITapGestureRecognizer) { }
}
