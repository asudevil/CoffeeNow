//
//  UserProfileDetailsCell.swift
//  CoffeeNow
//
//  Created by admin on 12/28/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class UserProfileDetailsCell: UICollectionViewCell {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Title: "
        return label
    }()
    var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Engineer"
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
        
        backgroundColor = UIColor.white
        
        addSubview(titleLabel)
        addSubview(title)
        
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 96).isActive = true
        
        title.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 5).isActive = true
        title.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        title.heightAnchor.constraint(equalToConstant: 30).isActive = true
        title.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
}
