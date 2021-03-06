//
//  ChatMsgSummaryCell.swift
//  CoffeeNow
//
//  Created by admin on 11/9/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase

class ChatMsgSummaryCell: UICollectionViewCell {
    
    var message: Message? {
        didSet {
            
            setupNameAndProfileImage()
            self.msgLabel.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                self.timeMsg.text = dateFormatter.string(from: timestampDate as Date)
            }
        }
    }
    
    private func setupNameAndProfileImage() {
        
        let chatPartnerId: String?
        
        if message?.fromID == FIRAuth.auth()?.currentUser?.uid {
            chatPartnerId = message?.toID
        } else {
            chatPartnerId = message?.fromID
        }
        
        if let id = chatPartnerId {
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.connectionName.text = dictionary["name"] as? String
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
            }, withCancel: nil)
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var connectionName: UILabel = {
        let label = UILabel()
        label.text = "Test 1 2, 1 2"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var msgLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timeMsg: UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        addSubview(profileImageView)
        addSubview(msgLabel)
        addSubview(dividerLineView)
        addSubview(connectionName)
        addSubview(timeMsg)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        connectionName.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        connectionName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 60).isActive = true
        connectionName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        connectionName.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        
        msgLabel.topAnchor.constraint(equalTo: connectionName.bottomAnchor, constant: 5).isActive = true
        msgLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 60).isActive = true
        msgLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        msgLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        
        dividerLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dividerLineView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        dividerLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        timeMsg.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeMsg.centerYAnchor.constraint(equalTo: topAnchor, constant: 18).isActive = true
        timeMsg.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeMsg.heightAnchor.constraint(equalTo: msgLabel.heightAnchor).isActive = true
        
    }
}
