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
    "bulbasaur",
    "ivysaur",
    "venusaur",
    "charmander",
    "charmeleon",
    "charizard",
    "squirtle",
    "wartortle",
    "blastoise",
    "caterpie"
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
