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
    var toId: String?
    var contactRequests = [ String: [Request] ]()
    var meetingLocations = [String]()
    var contactRequestsRef: FIRDatabaseReference!
    let usersRef = FIRDatabase.database().reference().child("users")
    let dateFormatter = DateFormatter()
    
    var fromIdButtonTags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Contact Requests"
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        
        guard let loggedInId = FIRAuth.auth()?.currentUser?.uid else {
            print("logged in ID could not be retrieved")
            return
        }
        
        toId = loggedInId
        contactRequestsRef = FIRDatabase.database().reference().child("contact-requests").child(loggedInId)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        tableView.register(RequestCell.self, forCellReuseIdentifier: cellId)
        
        monitorContactRequests()
    }
    
    func createRequestWithSnapshot(snapshot: FIRDataSnapshot) -> Request? {
        let request = Request()
        
        guard let requestDict = snapshot.value as? [String: AnyObject],
            let timeStamp = requestDict["timestamp"] as? Double,
            let meetingLocation = requestDict["meetingLocation"] as? String else {
                return nil
        }
        
        request.timeStampDate = Date(timeIntervalSince1970: timeStamp)
        request.fromId = snapshot.key
        request.meetingLocation = meetingLocation
        
        return request
    }
    
    func monitorContactRequests() {
        // check for contact request removals
        contactRequestsRef.observe(.childRemoved, with: { snapshot in
            
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
        contactRequestsRef.observe(.childAdded, with: { snapshot in

            guard let request = self.createRequestWithSnapshot(snapshot: snapshot), let meetingLocation = request.meetingLocation else {
                print("Contact request firebase reference is incomplete when checking for added child.")
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
        guard let incomingRequestFromId = incomingRequest.fromId else {
            print ("request missing fromID")
            return cell
        }
        
        cell.textLabel?.text = incomingRequest.name
        cell.detailTextLabel?.text = dateFormatter.string(from: requestTimeStamp)
        cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: requestProfileImageUrl)

        cell.ignoreButton.addTarget(self, action: #selector(ignoreRequest), for: .touchUpInside)
        cell.ignoreButton.tag = fromIdButtonTags.count
        cell.acceptButton.addTarget(self, action: #selector(acceptRequest), for: .touchUpInside)
        cell.acceptButton.tag = fromIdButtonTags.count
        fromIdButtonTags.append(incomingRequestFromId)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func acceptRequest(sender: UIButton) {
        let userIdMakingRequest = fromIdButtonTags[sender.tag]
        print("accepted from \(userIdMakingRequest)")
        
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
        let fromId = fromIdButtonTags[sender.tag]
        print("ignored from \(fromId)")
        
        if let toId = self.toId {
            let userRequestRef = FIRDatabase.database().reference().child("contact-requests/\(toId)/\(fromId)")
            userRequestRef.removeValue( completionBlock: { (error, ref) in
                if error != nil {
                    print("Ignoring request failed due to error: \(error)")
                } else {
                    self.tableView.reloadData()
                }
            })
        }
    }
}
