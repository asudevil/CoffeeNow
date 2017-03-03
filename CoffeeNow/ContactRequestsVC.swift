//
//  ContactRequestsVC.swift
//  CoffeeNow
//
//  Created by Roman Sheydvasser on 1/29/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class ContactRequestsVC: UITableViewController {
        
    let cellId = "cellId"
    var loggedInId: String!
    var contactRequests = [Request]()
    //var contactRequests = [MKPlacemark: [Request]]()
    var contactRequests2 = [ String: [String] ]()
    var contactRequests2keys = [String]()
    var contactRequests3 = [ String: [Request] ]()
    var contactRequests3keys = [String]()
    var contactRequestsRef: FIRDatabaseReference!
    var contactAddress: String!
    let usersRef = FIRDatabase.database().reference().child("users")
    let dateFormatter = DateFormatter()
    
    let business = "Sports Page"
    let geoSectionsCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Contact Requests"
        
        contactRequests2 = ["1 Infinite Loop, Cupertino" : ["Felix","Roman"], "2 Zero Loop, Sunnyvale" : ["Niki"]]
        contactRequests2keys = Array(contactRequests2.keys)
        
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
            var coordinateString = ""
            
            guard let requestDict = snapshot.value as? [String: Double],
                let timeStamp = requestDict["timestamp"],
                let contactLatitude = requestDict["latitude"],
                let contactLongitude = requestDict["longitude"] else {
                    print("Contact request firebase reference is incomplete.")
                    return
            }
            
            request.timeStampDate = Date(timeIntervalSince1970: timeStamp)
            request.id = snapshot.key
            //request.location = CLLocationCoordinate2D(latitude: contactLatitude, longitude: contactLongitude)
            coordinateString = "\(contactLatitude),\(contactLongitude)"
            
            if var requestArray = self.contactRequests3[coordinateString] {
                requestArray.append(request)
                print(self.contactRequests3[coordinateString] ?? "coordinate not found in firebase reference")
            } else {
                print(self.contactRequests3)
                self.contactRequests3[coordinateString] = [request]
            }
            print(self.contactRequests3)
            
            // get user info for contact requests
            self.usersRef.child(snapshot.key).observe(.value, with: { (snapshot) in
                
                if let userDict = snapshot.value as? [String: AnyObject] {
                    self.contactRequests3[coordinateString]?.last?.setValuesForKeys(userDict)
                    //self.contactRequests.append(request)
                    if self.contactRequests3.count > 0 {
                        // if let address = self.contactRequests3[self.contactAddress] {
                           // self.contactRequests3[self.contactAddress]?.append(request)
                       // } else {
                            // self.contactRequests3[self.contactAddress] = [request]
                        
                    } else {
                        self.contactRequests3[self.contactAddress] = [request]
                    }

                    
                    //this will crash because of background thread, so lets use dispatch_async to fix
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print(self.contactRequests3)
                }
                
            }, withCancel: nil)
            
            }
        , withCancel: nil)
    }
    
    func handleBack() {
        navigationController?.pop(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactRequests2[contactRequests2keys[section]]!.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactRequests2keys.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactRequests2keys[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RequestCell
        
        cell.textLabel?.text = contactRequests2[contactRequests2keys[indexPath.section]]?[indexPath.row]
        
        /*
        
        let request = contactRequests[indexPath.row]
        cell.textLabel?.text = request.name
        cell.detailTextLabel?.text = dateFormatter.string(from: request.timeStampDate!)
        
         if let profileImageUrl = request.profileImageUrl {
         cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
         }
 */

        cell.ignoreButton.addTarget(self, action: #selector(ignoreRequest), for: .touchUpInside)
        cell.ignoreButton.tag = indexPath.row
        cell.acceptButton.addTarget(self, action: #selector(acceptRequest), for: .touchUpInside)
        cell.acceptButton.tag = indexPath.row
        
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
    
    func ignoreRequest(sender: UIButton) {
        let row = sender.tag
        print("ignored from \(row)")
    }
}
