//
//  UserAnnotation.swift
//  CoffeeNow
//
//  Created by admin on 11/2/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import Foundation
import MapKit

let userProfiles = [
    "New1",
    "Test 35",
    "Niki",
    "Tester 13",
    "The President",
    "John Snow",
    "Rose",
    "Tester1",
    "Tester 33",
    "Ned Stak"
]

class UserAnnotation: NSObject, MKAnnotation {
    
    var coordinate = CLLocationCoordinate2D()
    var userNumber:  Int
    var userName: String
    var title: String?
    
    
    init(coordinate: CLLocationCoordinate2D, userNumber: Int) {
        self.coordinate = coordinate
        self.userNumber = userNumber
        self.userName = userProfiles[userNumber - 1].capitalized
        self.title = self.userName
    }
}
