//
//  MainView+MapView+Extension.swift
//  CoffeeNow
//
//  Created by admin on 12/24/16.
//  Copyright © 2016 CodeWithFelix. All rights reserved.
//

import UIKit
import MapKit
import Firebase

extension MainViewController {
    
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
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {        
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        showSightingsOnMap(location: loc)
    }
    func clickedSettings (_ button: UIButton) {
        optionsSelector.showOptions()
    }
    func editProfileTapped() {
        let editProfileController = EditProfileVC()
        navigationController?.pushViewController(editProfileController, animated: true)
    }
    func changeSettingsTapped() {
        let changeSettingsVC = ChangeSettings()
        navigationController?.pushViewController(changeSettingsVC, animated: true)
    }
    func myAccountTapped() {
        let myAccountVC = MyAccount()
        navigationController?.pushViewController(myAccountVC, animated: true)
    }
    
    func createSighting(forLocation location: CLLocation, withUser userId: String) {
        geofire.setLocation(location, forKey: "\(userId)")
    }
    
    
    func handleNewMessage() {
        let layout = UICollectionViewFlowLayout()
        let messagesController = MessagesController(collectionViewLayout: layout)
        navigationController?.pushViewController(messagesController, animated: true)
    }
    
    func setupViewsAndButtons() {
        view.addSubview(mapView)
        view.addSubview(randomPerson)
        view.addSubview(settingBtn)
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        
        settingBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35).isActive = true
        settingBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        settingBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        settingBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        randomPerson.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -35).isActive = true
        randomPerson.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        randomPerson.widthAnchor.constraint(equalToConstant: 50).isActive = true
        randomPerson.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}
