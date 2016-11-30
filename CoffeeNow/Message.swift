//
//  Message.swift
//  CoffeeNow
//
//  Created by admin on 11/8/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromID: String?
    var toID: String?
    var name: String?
    var text: String?
    var timestamp: NSNumber?
    
    func chatPartnerId() -> String? {
        return fromID == FIRAuth.auth()?.currentUser?.uid ? toID : fromID
    }
}
