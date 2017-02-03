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
    var contactRequests = [Request]()
    var contactRequestsRef: FIRDatabaseReference!
    let usersRef = FIRDatabase.database().reference().child("users")
    let dateFormatter = DateFormatter()
    
    let business = "Sports Page"
    let city = "Mountain View"
    let geoSectionsCount = 1
    
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

            let request = Request()
            
            if let requestDict = snapshot.value as? [String: AnyObject] {
                let timeStamp = requestDict["timestamp"] as? Double ?? 0
                request.timeStampDate = Date(timeIntervalSince1970: timeStamp)
            }
            
            // get user info for contact requests
            self.usersRef.child(snapshot.key).observe(.value, with: { (snapshot) in
                
                if let userDict = snapshot.value as? [String: AnyObject] {
                    request.setValuesForKeys(userDict)
                    self.contactRequests.append(request)
                    
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
        return contactRequests.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return geoSectionsCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\"\(business)\" in \(city)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RequestCell
        
        let request = contactRequests[indexPath.row]
        cell.textLabel?.text = request.name
        
        cell.detailTextLabel?.text = dateFormatter.string(from: request.timeStampDate!)
        cell.declineButton.addTarget(self, action: #selector(declineRequest), for: .touchUpInside)
        cell.declineButton.tag = indexPath.row
        cell.acceptButton.addTarget(self, action: #selector(acceptRequest), for: .touchUpInside)
        cell.acceptButton.tag = indexPath.row
        
        if let profileImageUrl = request.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func acceptRequest(sender: UIButton) {
        let row = sender.tag
        print("accepted from \(row)")
        
        /*
        guard let toId = contactId else {return }
        let fromId = FIRAuth.auth()!.currentUser!.uid
        
        let refId = fromId + toId
        
        let ref = FIRDatabase.database().reference().child("contacts-permissions")
        let childRef = ref.child(refId)
        
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = [requestType: "Yes", "toID": toId, "fromID": fromId, "timestamp": timestamp] as [String : Any]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            } else {
                success(true)
            }
        }
        
        let userRequestsRef = FIRDatabase.database().reference().child("contact-requests/\(toId)/\(fromId)")
        userRequestsRef.setValue(["timestamp": timestamp])
        */
    }
    
    func declineRequest(sender: UIButton) {
        let row = sender.tag
        print("declined from \(row)")
    }
}
