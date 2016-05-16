//
//  ViewController.swift
//  MapKitDemos
//
//  Created by HackerU on 16/05/2016.
//  Copyright © 2016 HackerU. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake{
            print("Shaked")
        }
    }


    @IBAction func mapTypeChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Satellite
        case 2:
            mapView.mapType = .Hybrid
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 10.0
        locationManager.requestAlwaysAuthorization()
        
        //one time location request
        //locationManager.requestLocation()
        
        //location updates:
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.showsBuildings = true
    }
}

extension ViewController : CLLocationManagerDelegate{
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        let coords = locations[0].coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(coords, 100, 100)
        
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways{
            print("Yay")
        }
        else if status == .Denied || status == .NotDetermined{
            print("No permissions yet")
        }
    }
}

extension ViewController: MKMapViewDelegate{
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        //
    }
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        //
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        //
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        //
    }
}
