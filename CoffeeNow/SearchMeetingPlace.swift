//
//  SearchMeetingPlace.swift
//  CoffeeNow
//
//  Created by admin on 1/2/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

class SearchMeetingPlace: UIViewController {
    
    var userPin = CLLocation()
    var contactPin = CLLocation()
    
    var midpointRegion = MKCoordinateRegion()
    
    let mapView: MKMapView = {
        let mp = MKMapView()
        mp.backgroundColor = UIColor.brown
        mp.translatesAutoresizingMaskIntoConstraints = false
        return mp
    }()
    let getLocationBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .red
        btn.titleLabel?.text = "Show Locations"
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(performSearch), for: .touchUpInside)
       return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapViews()

        // add users to map
        let user1 = MKPointAnnotation()
        user1.coordinate = userPin.coordinate
        user1.title = "user1"
        let user2 = MKPointAnnotation()
        user2.coordinate = contactPin.coordinate
        user2.title = "user2"
        
        mapView.addAnnotation(user1)
        mapView.addAnnotation(user2)
        
        
        // set map view to show both users
        mapView.showAnnotations([user1, user2], animated: true)
        view.backgroundColor = .white
        
        performSearch()
        

    }
    
    func performSearch() {
        // use MKLocalSearch API to find coffee places
        let midpointLat = (userPin.coordinate.latitude + contactPin.coordinate.latitude)/2
        let midpointLon = (userPin.coordinate.longitude + contactPin.coordinate.longitude)/2
        let midpointCoord = CLLocationCoordinate2D(latitude: midpointLat, longitude: midpointLon)
        
        // set search region to be a square with an area of half the distance between the 2 users
        let midpointRegionSpan = userPin.distance(from: contactPin) / 2
        let midpointRegion = MKCoordinateRegionMakeWithDistance(midpointCoord, midpointRegionSpan, midpointRegionSpan)
        
        // use MKLocalSearch API to find coffee places
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "coffee"
        request.region = midpointRegion
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            guard let response = response else {
                print("Search error: \(error)")
                return
            }
            // add coffee shops to map
            for place in response.mapItems {
                print("\(place.name)")
                let placeAnno = MKPointAnnotation()
                placeAnno.coordinate = place.placemark.coordinate
                placeAnno.title = place.name
                self.mapView.addAnnotation(placeAnno)
            }
        }
    }
    func setupMapViews() {
        
        view.addSubview(getLocationBtn)
        view.addSubview(mapView)
        
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        getLocationBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getLocationBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        getLocationBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        getLocationBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true

    }
    


}
