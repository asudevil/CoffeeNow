//
//  UserAnnotation.swift
//  CoffeeNow
//
//  Created by admin on 11/2/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import Foundation
import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    
    var coordinate = CLLocationCoordinate2D()
    var userNumber:  String
    var userName: String
    var title: String?
    var imageUrl: String?
    var imageView: UIImageView?
    
    
    init(coordinate: CLLocationCoordinate2D, userId: String, userName: String, profileImageUrl: String, profileImage: UIImageView?) {
        self.coordinate = coordinate
        self.userNumber = userId
        self.userName = userName.capitalized
        self.title = self.userName
        self.imageUrl = profileImageUrl
        self.imageView = profileImage
    }
}
