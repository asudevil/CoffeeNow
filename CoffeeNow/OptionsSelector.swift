//
//  OptionsSelector.swift
//  CoffeeNow
//
//  Created by admin on 12/10/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit

class OptionsSelector: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let settingOptions = ["Contacts","Change Settings","Edit Profile","My Account","Logout"]
    let settingsImages = ["contacts", "settings", "editProfile", "myAccount", "logout"]
    let cellId = "cellId"
    let cellHeight: CGFloat = 55
    
    var selectedProduct: String!
    
    var mainViewController: MainViewController?
    
    let blackView = UIView()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OptionsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OptionsCell
        
        cell.nameLabel.text = settingOptions[indexPath.item]
        cell.selectedImage = settingsImages[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        handleDismiss(indexPath.item)
    }
    
    func showOptions () {
        
        if let window = UIApplication.shared.keyWindow {
            
            let height: CGFloat = CGFloat(settingOptions.count) * cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            collectionView.backgroundColor = UIColor.gray
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            blackView.frame = window.frame
            blackView.alpha = 0
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    func handleDismiss(_ selectedOption: Int) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            
        }) { (completed: Bool) in
                        
            switch selectedOption {
            case 0:
                self.mainViewController?.contactsTabTapped()
            case 1:
                self.mainViewController?.changeSettingsTapped()
            case 2:
                self.mainViewController?.editProfileTapped()
            case 3:
                self.mainViewController?.myAccountTapped()
            case 4:
                self.mainViewController?.handleLogout()
            default:
                print("Do nothing")
            }
        }
    }
}

