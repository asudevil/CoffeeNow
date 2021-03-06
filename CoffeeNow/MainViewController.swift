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
    private var selectedUserDetails = [String: Any]()
    private var selectedUserpermissions = [String: Any]()
    private var selectedUserLocation: CLLocationCoordinate2D!
    
    let mapView: MKMapView = {
       let mp = MKMapView()
        mp.backgroundColor = UIColor.brown
        mp.translatesAutoresizingMaskIntoConstraints = false
        return mp
    }()
 
    let pinMeHereBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "setLocation50"), for: .normal)
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
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "menu"), for: .normal)
        return btn
    }()
    
    lazy var locationSpotter: UIImageView = {
        let spot = UIImageView()
        spot.translatesAutoresizingMaskIntoConstraints = false
        spot.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        spot.layer.masksToBounds = true
        spot.image = UIImage(named: "location")
        spot.contentMode = .scaleAspectFill
        spot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLocationSpotter)))
        return spot
    }()
    
    lazy var optionsSelector: OptionsSelector = {
        let launcher = OptionsSelector()
        launcher.mainViewController = self
        return launcher
    }()
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        geoFireRef = FIRDatabase.database().reference().child("location")
        geofire = GeoFire(firebaseRef: geoFireRef)
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let newMessageBtnImage = UIImage(named: "speechBubble")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageBtnImage, style: .plain, target: self, action: #selector(handleNewMessage))
        pinMeHereBtn.addTarget(self, action: #selector(spotUserAtLocation), for: .touchUpInside)
        settingBtn.addTarget(self, action: #selector(clickedSettings), for: .touchUpInside)
        setupViewsAndButtons()
        loadProfileDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        loggedInId = uid
        locationAuthStatus()
        locationSpotter.isHidden = false
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 3000, 3000)
        
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
            
            let uid = selectedAnnotation.userNumber
            ProfileDetails.sharedInstance.fetchUserInfofromServer(uid: uid, completion: { (userDetailsDictionary) in
                self.selectedUserDetails = userDetailsDictionary
            })
            
            ProfileDetails.sharedInstance.fetchUserPermissions(fromId: loggedInId, toId: uid) { (permissionDetails) in
                self.selectedUserpermissions = permissionDetails
            }
            
            selectedUserLocation = selectedAnnotation.coordinate
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annoIdentifier = "Profile"
        var annotationView: MKAnnotationView?
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
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
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 15
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
            
            if let profileImageView = anno.imageView {
                imageView.image = profileImageView.image
            } else {
                imageView.image = UIImage(named: "profileImage")
            }
            
            UIGraphicsBeginImageContext(imageView.bounds.size)
            imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            annotationView.image = resizedImage

            let mapBtn = UIButton()
            mapBtn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            mapBtn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = mapBtn
            
            let chatBtn = UIButton()
            chatBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            chatBtn.setImage(UIImage(named: "chat50"), for: .normal)
            chatBtn.addTarget(self, action: #selector(showChatMessage), for: .touchUpInside)
            
            let profileDetailsAnno = UIButton()
            profileDetailsAnno.frame = CGRect(x: 35, y: 0, width: 35, height: 35)
            profileDetailsAnno.setImage(UIImage(named: "contactCard50"), for: .normal)
            profileDetailsAnno.addTarget(self, action: #selector(profileDetailsTap), for: .touchUpInside)
            
            annoContainer.frame = CGRect(x: 0, y: 0, width: 70, height: 40)
            annoContainer.addSubview(chatBtn)
            annoContainer.addSubview(profileDetailsAnno)
            annotationView.leftCalloutAccessoryView = annoContainer
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let selectedUser = view.annotation as? UserAnnotation {
            
            //Give you directions to location
//                let place = MKPlacemark(coordinate: selectedUser.coordinate)
//                let destination = MKMapItem(placemark: place)
//                destination.name = "User sighting"
//                let regionDistance: CLLocationDistance = 1000
//                let regionSpan = MKCoordinateRegionMakeWithDistance(selectedUser.coordinate, regionDistance, regionDistance)
//                let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String : Any]
//                MKMapItem.openMaps(with: [destination], launchOptions: options)
//        
        
            //Prepare locations to search for meeting place
            
            let lat = mapView.userLocation.coordinate.latitude
            let lon = mapView.userLocation.coordinate.longitude
            
            let userLoc = CLLocation(latitude: lat, longitude: lon)
            
            
        //    let userLoc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            let contactLoc = CLLocation(latitude: selectedUser.coordinate.latitude, longitude: selectedUser.coordinate.longitude)
        
            let searchmeetingPlaceVC = SearchMeetingPlace()
            searchmeetingPlaceVC.userPin = userLoc
            searchmeetingPlaceVC.contactPin = contactLoc

            navigationController?.pushViewController(searchmeetingPlaceVC, animated: true)
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
        let layout = UICollectionViewFlowLayout()
        
        let profileDetailsController = UserProfileCollectionVC(collectionViewLayout: layout)
        profileDetailsController.profileBasicInfo = selectedAnno
        let selectedProfileID = selectedAnno.userNumber
        profileDetailsController.contactId = selectedProfileID
        profileDetailsController.contactDetailDictionary = selectedUserDetails
        profileDetailsController.permissionsDictionary = selectedUserpermissions
        profileDetailsController.contactLocation = selectedUserLocation

        
        navigationController?.pushViewController(profileDetailsController, animated: true)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        showSightingsOnMap(location: CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude))
    }
    
    func showSightingsOnMap(location: CLLocation) {
        let circleQuery = geofire.query(at: location, withRadius: 5)
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
                            let profileImage = UIImageView()
                            profileImage.loadImageUsingCacheWithUrlString(urlString: profileImageUrl) {
                                (error) in
                                if let error = error {
                                    print(error)
                                    profileImage.image = UIImage(named: "profileImage")
                                }
                                
                                let anno = UserAnnotation(coordinate: location.coordinate, userId: key, userName: userName, profileImageUrl: profileImageUrl, profileImage: profileImage)
                                
                                DispatchQueue.main.async {
                                    self.mapView.addAnnotation(anno)
                                }
                            }
                        }
                    }
                }, withCancel: nil)
            }
        })
    }
    
    func spotUserAtLocation() {
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        //clear previous location if any.
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        //set new location
        createSighting(forLocation: loc, withUser: loggedInId)
        showSightingsOnMap(location: loc)
    }
    
    func fetchUserAndSetupNavBarTitle() {        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                self.loggedInUserName = dictionary["name"] as? String
                self.navigationItem.title = "Map"
            }
        }, withCancel: nil)
    }
    func loadProfileDetails() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        ProfileDetails.sharedInstance.fetchUserInfofromServer(uid: uid) { (dictionary) in
            ProfileDetails.sharedInstance.setProfileDetails(profileDictionary: dictionary)
        }
    }
    
    func handleLogout() {
        
        do { try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logOut()
        ProfileDetails.sharedInstance.allDetailsDictionary?.removeAll()

        let loginController = LoginController()
        loginController.mainVC = self
        present(loginController, animated: true, completion: nil)
    }
    
    func tapLocationSpotter() {
        print("Location spotter tapped")
    }
}

