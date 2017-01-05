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
    let locationListBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.text = "Show Locations"
        btn.setTitleColor(.white, for: .normal)
        btn.setImage(UIImage(named: "list-icon"), for: .normal)
        btn.layer.masksToBounds = true
        btn.contentMode = .scaleAspectFill
        btn.addTarget(self, action: #selector(showMeetingLocationTable), for: .touchUpInside)
       return btn
    }()
    
    lazy var meetingLocSelector: MeetingLocResults = {
        let launcher = MeetingLocResults()
        launcher.meetingPlace = self
        return launcher
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapViews()

        // add users to map
        let user1 = MKPointAnnotation()
        user1.coordinate = userPin.coordinate
        user1.title = "Me"
        let user2 = MKPointAnnotation()
        user2.coordinate = contactPin.coordinate
        user2.title = "New Contact"
        
        mapView.addAnnotation(user1)
        mapView.addAnnotation(user2)
        
        if let userAnno = mapView.annotations.first {

        }
        
        
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
                if let location = place.name {
                    self.meetingLocSelector.meetingLocName.append(location)
                }
                
                let placeAnno = MKPointAnnotation()
                placeAnno.coordinate = place.placemark.coordinate
                placeAnno.title = place.name
                self.mapView.addAnnotation(placeAnno)
            }
        }
    }
    
    func showMeetingLocationTable() {
        meetingLocSelector.showLocations()
    }
    func setupMapViews() {
        
        view.addSubview(mapView)
        view.addSubview(locationListBtn)
        
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        locationListBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        locationListBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        locationListBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        locationListBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
