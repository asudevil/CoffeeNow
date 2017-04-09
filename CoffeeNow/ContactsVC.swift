//
//  ContactsVC.swift
//  CoffeeNow
//
//  Created by Roman Sheydvasser on 1/21/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase

class ContactsVC: UITableViewController {
    
    let cellId = "cellId"
    var toId: String?
    var contactRequests = [ String: [Request] ]()
    var meetingLocations = [String]()
    var contactsRef: FIRDatabaseReference!
    let usersRef = FIRDatabase.database().reference().child("users")
    let dateFormatter = DateFormatter()
    
    var requestButtonTags = [Request?]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        monitorContactRequests()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        contactRequests.removeAll()
        meetingLocations = []
        requestButtonTags = []
        contactsRef.removeAllObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        
        guard let loggedInId = FIRAuth.auth()?.currentUser?.uid else {
            print("logged in ID could not be retrieved")
            return
        }
        
        toId = loggedInId
        contactsRef = FIRDatabase.database().reference().child("contacts").child(loggedInId)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        tableView.register(RequestCell.self, forCellReuseIdentifier: cellId)
    }
    
    func createRequestWithSnapshot(snapshot: FIRDataSnapshot) -> Request? {
        let request = Request()
        
        guard let requestDict = snapshot.value as? [String: AnyObject],
            let timeStamp = requestDict["timestamp"] as? Double,
            let meetingLocation = requestDict["meetingLocation"] as? String else {
                return nil
        }
        
        request.timestamp = timeStamp
        request.timeStampDate = Date(timeIntervalSince1970: timeStamp)
        request.fromId = snapshot.key
        request.meetingLocation = meetingLocation
        
        return request
    }
    
    func monitorContactRequests() {
        // check for contact request removals
        contactsRef.observe(.childRemoved, with: { snapshot in
            
            guard let request = self.createRequestWithSnapshot(snapshot: snapshot), let meetingLocation = request.meetingLocation else {
                print("Contact request firebase reference is incomplete when checking for removed child.")
                return
            }
            
            if var requestArrayAtLocation = self.contactRequests[meetingLocation] {
                for (index,existingRequest) in requestArrayAtLocation.enumerated() {
                    if existingRequest.fromId == request.fromId {
                        requestArrayAtLocation.remove(at: index)
                        continue
                    }
                }
                
                if requestArrayAtLocation.isEmpty {
                    self.contactRequests[meetingLocation] = nil
                    self.meetingLocations = Array(self.contactRequests.keys)
                } else {
                    self.contactRequests[meetingLocation] = requestArrayAtLocation
                }
            }
            
            self.tableView.reloadData()
            
        })
        
        
        // check for contact request additions
        contactsRef.observe(.childAdded, with: { snapshot in
            
            guard let request = self.createRequestWithSnapshot(snapshot: snapshot) else {
                print("contactsVC: Contact request firebase reference is incomplete when checking for added child.")
                return
            }
            
            guard let meetingLocation = request.meetingLocation else {
                print("contactsVC: Request missing meeting location.")
                return
            }
            
            if var requestArrayAtLocation = self.contactRequests[meetingLocation] {
                requestArrayAtLocation.append(request)
                self.contactRequests[meetingLocation] = requestArrayAtLocation
            } else {
                self.contactRequests[meetingLocation] = [request]
            }
            self.meetingLocations = Array(self.contactRequests.keys)
            
            // get and set name and profileImageUrl for user requesting contact info
            self.usersRef.child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let userDict = snapshot.value as? [String: AnyObject] {
                    self.contactRequests[meetingLocation]?.last?.setValuesForKeys(userDict)
                    self.tableView.reloadData()
                }
            })
        })
    }
    
    func handleBack() {
        navigationController?.pop(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let contactRequestsSection = contactRequests[meetingLocations[section]] {
            return contactRequestsSection.count
        } else {
            return 0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return meetingLocations.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return meetingLocations[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RequestCell
        
        guard let requestsAtMeetingLocation = contactRequests[meetingLocations[indexPath.section]],
            let requestTimeStamp = requestsAtMeetingLocation[indexPath.row].timeStampDate,
            let requestProfileImageUrl = requestsAtMeetingLocation[indexPath.row].profileImageUrl else {
                print("no sections found, timestamp error, or profile image error")
                return cell
        }
        
        let incomingRequest = requestsAtMeetingLocation[indexPath.row]
        
        cell.textLabel?.text = incomingRequest.name
        cell.detailTextLabel?.text = dateFormatter.string(from: requestTimeStamp)
        cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: requestProfileImageUrl)
        
        cell.acceptButton.isHidden = true
        cell.ignoreButton.addTarget(self, action: #selector(removeContact), for: .touchUpInside)
        cell.ignoreButton.tag = requestButtonTags.count
        cell.ignoreButton.setTitle("Delete", for: .normal)
        requestButtonTags.append(incomingRequest)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func removeContact(sender: UIButton) {
        let contactRequest = requestButtonTags[sender.tag]
        
        if let toId = self.toId, let request = contactRequest, let fromId = request.fromId {
            let userRequestRef = FIRDatabase.database().reference().child("contacts/\(toId)/\(fromId)")
            userRequestRef.removeValue( completionBlock: { (error, ref) in
                if let error = error {
                    print("Ignoring request failed due to error: \(error)")
                } else {
                    self.tableView.reloadData()
                }
            })
        }
    }
}
