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
        locationManager.requestAlwaysAuthorization()
    }
}

extension ViewController : CLLocationManagerDelegate{
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
