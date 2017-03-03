//
//  UIElements.swift
//  CoffeeNow
//
//  Created by Roman Sheydvasser on 1/30/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {
    
    var acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Accept", for: .normal)
        return button
    }()
    
    var ignoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Ignore", for: .normal)
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier);

        addSubview(ignoreButton)
        ignoreButton.leftAnchor.constraint(equalTo: self.rightAnchor, constant: -80).isActive = true
        ignoreButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ignoreButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        ignoreButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(acceptButton)
        acceptButton.leftAnchor.constraint(equalTo: self.rightAnchor, constant: -150).isActive = true
        acceptButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        acceptButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        acceptButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 65, y: textLabel!.frame.origin.y - 3, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 65, y: detailTextLabel!.frame.origin.y + 3, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }

}
