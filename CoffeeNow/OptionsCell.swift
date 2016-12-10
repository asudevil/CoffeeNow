//
//  OptionsCell.swift
//  CoffeeNow
//
//  Created by admin on 12/10/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class OptionsCell: UICollectionViewCell {
    
    var selectedImage: String? {
        didSet {
            guard let imageName = selectedImage else {return }
            iconImageView.image = UIImage(named: imageName)
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Default"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        
        addSubview(iconImageView)
        addSubview(nameLabel)

        iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 30).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = UIColor.white
    }

}
