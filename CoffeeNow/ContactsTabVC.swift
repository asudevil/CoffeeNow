//
//  ContactsTabVC.swift
//  CoffeeNow
//
//  Created by Roman Sheydvasser on 3/15/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

class ContactsTabVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let tabOne = ContactsVC()
        let tabOneBarItem = UITabBarItem(title: "My Contacts", image: UIImage(named: "contactsTab"), selectedImage: nil)
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let tabTwo = ContactRequestsVC()
        let tabTwoBarItem2 = UITabBarItem(title: "Requests", image: UIImage(named: "contactsTab"), selectedImage: nil)
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        
        self.viewControllers = [tabOne, tabTwo]
    }
}
