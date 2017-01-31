//
//  ContactRequestsVC.swift
//  CoffeeNow
//
//  Created by Roman Sheydvasser on 1/29/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase

class ContactRequestsVC: UITableViewController {
        
    let cellId = "cellId"
    var loggedInId: String!
    var users = [User]()
    var requestTimestamp: Double!
    var requestTimestampDate: Date!
    var contactRequestsRef: FIRDatabaseReference!
    let usersRef = FIRDatabase.database().reference().child("users")
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Contact Info Requests"
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        loggedInId = uid
        contactRequestsRef = FIRDatabase.database().reference().child("contact-requests").child(loggedInId)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        tableView.register(RequestCell.self, forCellReuseIdentifier: cellId)
        
        fetchContactRequests()
    }
        
    func fetchContactRequests() {
        // check for contact requests
        contactRequestsRef.observe(.childAdded, with: { snapshot in

            if let requestDict = snapshot.value as? [String: AnyObject] {
                self.requestTimestamp = requestDict["timestamp"] as? Double ?? 0
                self.requestTimestampDate = Date(timeIntervalSince1970: self.requestTimestamp)
            }
            
            // get user info for contact requests
            self.usersRef.child(snapshot.key).observe(.value, with: { (snapshot) in
                
                if let userDict = snapshot.value as? [String: AnyObject] {
                    let user = User()
                    user.setValuesForKeys(userDict)
                    self.users.append(user)
                    
                    //this will crash because of background thread, so lets use dispatch_async to fix
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            }, withCancel: nil)
            
            }
        , withCancel: nil)
    }

    func handleBack() {
        navigationController?.pop(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\"Sports Page\" in Mountain View"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RequestCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        
        cell.detailTextLabel?.text = dateFormatter.string(from: requestTimestampDate)
        cell.declineButton.addTarget(self, action: #selector(declineRequest), for: .touchUpInside)
        cell.acceptButton.addTarget(self, action: #selector(acceptRequest), for: .touchUpInside)
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func acceptRequest() {
        print("accepted")
    }
    
    func declineRequest() {
        print("declined")
    }
}
