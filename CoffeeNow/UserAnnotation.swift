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
    var userNumber:  String
    var userName: String
    var title: String?
    var imageUrl: String?
    
    
    init(coordinate: CLLocationCoordinate2D, userId: String, userName: String, profileImageUrl: String) {
        self.coordinate = coordinate
        self.userNumber = userId
        self.userName = userName.capitalized
        self.title = self.userName
        self.imageUrl = profileImageUrl
    }
}
