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
import FBSDKLoginKit

class MainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    var geofire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    private var loggedInUserName: String!
    private var loggedInId: String!
    private var selectedAnno: UserAnnotation!
        
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
    
    let annoContainer: UIView = {
       let container = UIView()
        container.backgroundColor = UIColor.white
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.masksToBounds = true
        return container
    }()
    
    let settingBtn: UIButton = {
       let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "settings"), for: .normal)
        return btn
    }()
    
    lazy var locatonSpotter: UIView = {
        let spot = UIView()
        spot.translatesAutoresizingMaskIntoConstraints = false
        spot.frame = CGRect(x: self.view.frame.width/2  , y: self.view.frame.height/2, width: 10, height: 10)
        spot.layer.cornerRadius = 5
        spot.backgroundColor = UIColor.blue
        spot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLocationSpotter)))
        return spot
    }()
    
    lazy var optionsSelector: OptionsSelector = {
        let launcher = OptionsSelector()
        launcher.mainViewController = self
        return launcher
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
        randomPerson.addTarget(self, action: #selector(spotUserAtLocation), for: .touchUpInside)
        settingBtn.addTarget(self, action: #selector(clickedSettings), for: .touchUpInside)
        setupViewsAndButtons()
        loadProfileDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        checkIfUserIsLoggedIn()
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        loggedInId = uid
        locationAuthStatus()
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let selectedAnnotation = view.annotation as? UserAnnotation {
            selectedAnno = selectedAnnotation
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
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 25
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            
            if let url = anno.imageUrl {
                imageView.loadImageUsingCacheWithUrlString(urlString: url)
            } else {
                imageView.image = UIImage(named: "profileImage")
            }
            
            UIGraphicsBeginImageContext(imageView.bounds.size)
            imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            annotationView.image = resizedImage

            let mapBtn = UIButton()
            mapBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            mapBtn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = mapBtn
            
            let chatBtn = UIButton()
            chatBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            chatBtn.setImage(UIImage(named: "chatBtn"), for: .normal)
            chatBtn.addTarget(self, action: #selector(showChatMessage), for: .touchUpInside)
            
            let profileDetailsAnno = UIButton()
            profileDetailsAnno.frame = CGRect(x: 30, y: 0, width: 20, height: 40)
            profileDetailsAnno.setImage(UIImage(named: "profileImage"), for: .normal)
            profileDetailsAnno.addTarget(self, action: #selector(profileDetailsTap), for: .touchUpInside)
            
            annoContainer.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
            annoContainer.addSubview(chatBtn)
            annoContainer.addSubview(profileDetailsAnno)
            annotationView.leftCalloutAccessoryView = annoContainer
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let selectedUser = view.annotation as? UserAnnotation {
            
            //configuring Apple Map
                
                let place = MKPlacemark(coordinate: selectedUser.coordinate)
                let destination = MKMapItem(placemark: place)
                destination.name = "User sighting"
                let regionDistance: CLLocationDistance = 1000
                let regionSpan = MKCoordinateRegionMakeWithDistance(selectedUser.coordinate, regionDistance, regionDistance)
                let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
                MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
    }
    
    func showChatMessage() {
        let userToChatWith = User()
        userToChatWith.id = selectedAnno.userNumber
        userToChatWith.name = selectedAnno.userName
        userToChatWith.profileImageUrl = selectedAnno.imageUrl
        
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = userToChatWith
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func profileDetailsTap() {
        let profileDetailsController = ProfileDetailsVC()
        profileDetailsController.profileAnno = selectedAnno
        
        navigationController?.pushViewController(profileDetailsController, animated: true)
    }
    
    func showSightingsOnMap(location: CLLocation) {
        let circleQuery = geofire.query(at: location, withRadius: 4.5)
        var userName = "No Name"
        
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, locationIn) in
            
            if let key = key, let location = locationIn {
                
                FIRDatabase.database().reference().child("users").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: Any] {
                        guard let profileImageUrl = dictionary["profileImageUrl"] as? String else {
                            return
                        }
                        if let name = dictionary["name"] as? String {
                            userName = name
                            let anno = UserAnnotation(coordinate: location.coordinate, userId: key, userName: userName, profileImageUrl: profileImageUrl)
                            self.mapView.addAnnotation(anno)
                        }
                    }
                }, withCancel: nil)
            }
        })
    }
    
    func spotUserAtLocation() {
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        createSighting(forLocation: loc, withUser: loggedInId)
        print("Setting location for uid: \(loggedInId)")
        locatonSpotter.isHidden = true
        viewDidLoad()
    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                self.loggedInUserName = dictionary["name"] as? String
                self.navigationItem.title = self.loggedInUserName
            }
        }, withCancel: nil)
    }
    func loadProfileDetails() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        FIRDatabase.database().reference().child("users-details").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                ProfileDetails.sharedInstance.setProfileDetails(profileDictionary: dictionary)
            }
        }, withCancel: nil)
    }
    
    func handleLogout() {
        
        do { try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logOut()
        
        ProfileDetails.sharedInstance.allDetailsDictionary?.removeAll()
        
        //ProfileDetails.sharedInstance.setProfileDetails(profileDictionary: blankProfile)
        
        print("Did Logout")

        let loginController = LoginController()
        loginController.messageController = self
        present(loginController, animated: true, completion: nil)
    }
    
    func tapLocationSpotter() {
        print("Location spotter tapped")
    }
}

