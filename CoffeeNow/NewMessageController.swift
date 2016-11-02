//
//  NewMessageController.swift
//  CoffeeNow
//
//  Created by admin on 10/29/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()

    }
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let user = User()
                
                    //If you use this setter, your app will crash if your class properties don't excacly match up with the firebase dictionary keys
                       user.setValuesForKeys(dictionary)
                
                self.users.append(user)
                
                //Must use dispatch_async since this is in the background thread.  If not this will crash.
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedUser = users[indexPath.row]
        
        let layout = UICollectionViewFlowLayout()
        let chatLogController = ChatLogController(collectionViewLayout: layout, userInput: selectedUser)
            
        navigationController?.pushViewController(chatLogController, animated: true)
    }

}
