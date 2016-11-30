//
//  MainViewController.swift
//  CoffeeNow
//
//  Created by admin on 10/25/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class MainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var geofire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    
    let mapView: MKMapView = {
       let mp = MKMapView()
        mp.backgroundColor = UIColor.brown
        mp.translatesAutoresizingMaskIntoConstraints = false
        return mp
        
    }()
 
    let randomPerson: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.setImage(UIImage(named: "coffeeLogo"), for: .normal)
        return button
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        geoFireRef = FIRDatabase.database().reference().child("location")
        geofire = GeoFire(firebaseRef: geoFireRef)
        
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "list-icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        randomPerson.addTarget(self, action: #selector(spotRandomPerson), for: .touchUpInside)

        //Map views
        view.addSubview(mapView)
        view.addSubview(randomPerson)
        setupMapContainerView()
        setupSpotPersonButton()
        
        // user is not logged in
        checkIfUserIsLoggedIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if let loc = userLocation.location {
            if !mapHasCenteredOnce {
                centerMapOnLocation(location: loc)
                mapHasCenteredOnce = true
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annoIdentifier = "Profile"
        var annotationView: MKAnnotationView?
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "profileImage")
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
            annotationView = deqAnno
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView, let anno = annotation as? UserAnnotation {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "\(anno.userNumber)")
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
            
            let chatBtn = UIButton()
            chatBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            chatBtn.setImage(UIImage(named: "chatBtn"), for: .normal)
            chatBtn.addTarget(self, action: #selector(showChatMessage), for: .touchUpInside)
            annotationView.leftCalloutAccessoryView = chatBtn
        }
        return annotationView
    }
    
    var clickedChatMessage = false
    
    func showChatMessage() {
        print("Show Chat Message")
        clickedChatMessage = true
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        showSightingsOnMap(location: loc)
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //configuring Apple Map
        if clickedChatMessage == false {
            
            if let anno = view.annotation as? UserAnnotation {
                let place = MKPlacemark(coordinate: anno.coordinate)
                let destination = MKMapItem(placemark: place)
                destination.name = "User sighting"
                let regionDistance: CLLocationDistance = 1000
                let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
                
                let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
                MKMapItem.openMaps(with: [destination], launchOptions: options)
                
                clickedChatMessage = false
            }
        } else {

            let layout = UICollectionViewFlowLayout()
            let messagesController = MessagesController(collectionViewLayout: layout)
            
            navigationController?.pushViewController(messagesController, animated: true)
            clickedChatMessage = false
        }
    }
    
    
    func createSighting(forLocation location: CLLocation, withUser userId: Int) {
        geofire.setLocation(location, forKey: "\(userId)")
    }
    
    func showSightingsOnMap(location: CLLocation) {
        let circleQuery = geofire.query(at: location, withRadius: 3.5)
        
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, locationIn) in
            
            if let key = key, let location = locationIn {
                let anno = UserAnnotation(coordinate: location.coordinate, userNumber: Int(key)!)
                
                print("showing sighting on map.  Coordinates: \(location.coordinate). \n Key is \(key)")
                
                self.mapView.addAnnotation(anno)
            }
            
        })
    }
    
    func spotRandomPerson() {
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        let rand = arc4random_uniform(10) + 1
        createSighting(forLocation: loc, withUser: Int(rand))
        
        print("Random number is: \(rand)")
    }

    
    func handleNewMessage() {

        
        let layout = UICollectionViewFlowLayout()
        let messagesController = MessagesController(collectionViewLayout: layout)
        
        navigationController?.pushViewController(messagesController, animated: true)
    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                self.navigationItem.title = dictionary["name"] as? String
            }
        }, withCancel: nil)
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        loginController.messageController = self
        present(loginController, animated: true, completion: nil)
    }
    
    func setupMapContainerView () {
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 500).isActive = true
    }

    func setupSpotPersonButton() {
        
        randomPerson.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35).isActive = true
        randomPerson.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35).isActive = true
        randomPerson.widthAnchor.constraint(equalToConstant: 50).isActive = true
        randomPerson.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

}

