//
//  MessagesController.swift
//  CoffeeNow
//
//  Created by admin on 11/12/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var user = User()
    let cellId = "cellId"
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    var timer: Timer?
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    override init(collectionViewLayout: UICollectionViewLayout) {
        super.init(collectionViewLayout: collectionViewLayout)
 //       self.user = userInput
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = user.name
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMsgSummaryCell.self, forCellWithReuseIdentifier: cellId)
        
        let image = UIImage(named: "newMessageIcon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))

        //remove all messages
        messages.removeAll()
        messagesDictionary.removeAll()
        collectionView?.reloadData()
        
        observeUserMessages()
    }
    
    func observeUserMessages() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageReference = FIRDatabase.database().reference().child("messages").child(messageId)
            
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message()
                    message.setValuesForKeys(dictionary)
                    if let chatPartnerId = message.chatPartnerId() {
                        self.messagesDictionary[chatPartnerId] = message
                        
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return message1.timestamp!.intValue > message2.timestamp!.intValue
                        })
                    }
                    
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                }
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    func handleReloadTable() {
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMsgSummaryCell
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User()
            user.id = chatPartnerId
            user.setValuesForKeys(dictionary)
            self.showChatControllerForUser(user)
            
        }, withCancel: nil)
    }
    
    func handleSend() {
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        guard let fromID = FIRAuth.auth()?.currentUser?.uid, let toID = user.id, let name = user.name, let sendText = inputTextField.text else {
            return
        }
        let timestamp = Int(NSDate.timeIntervalSinceReferenceDate)
        let values = ["text": sendText, "name": name, "toID": toID, "fromID": fromID, "timestamp": timestamp] as [String : Any]
        //        childRef.updateChildValues(values)
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromID)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toID)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
        }
        
        print("Message Sent")
    }
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}

