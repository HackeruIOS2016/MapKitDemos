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
    var geoCoder = CLGeocoder()
    
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        guard let location = locationManager.location else {return}
        
        if motion == .MotionShake{
            //            let annotation = PizaaAnnotiation(coordinate: location.coordinate, title: "Pizaa Gutte", subtitle: "Yammi Pizza")
            //
            //            mapView.addAnnotation(annotation)
            //
            //            geoCoder.reverseGeocodeLocation(location, completionHandler: { (places, error) -> Void in
            //                if let place = places?.first{
            //                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //                        print(place.addressDictionary)
            //                    })
            //                }
            //            })
            
            
            printMapDirections("השלום תל-אביב")
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50.0
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
        //print(locations)
        
        let coords = locations[0].coordinate
        
        let region = MKCoordinateRegionMakeWithDistance(coords, 100, 100)
        
        mapView.setRegion(region, animated: true)
        
        
        
        geoCoder.reverseGeocodeLocation(locations[0]) { (places, error) -> Void in
            if let place = places?.first{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    if let add = place.addressDictionary?["Name"] as? String{
                        let annotation = PizaaAnnotiation(coordinate: coords, title: "Yammi", subtitle: add)
                        self.mapView.addAnnotation(annotation)
                    }
                    
                })
            }
        }
        
    }
    
    func openMapDirections(query:String){
        //1) get the coordinates from the geocoder
        geoCoder.geocodeAddressString(query) { (places, error) -> Void in
            
            let dest = MKPlacemark(placemark: places!.first!)
            let destMapItem = MKMapItem(placemark: dest)
            
            //2) open the maps app to get directions
            MKMapItem.openMapsWithItems([destMapItem], launchOptions: nil)
        }
    }
    
    
    
    func printMapDirections(query:String){
        //1) get the coordinates from the geocoder
        geoCoder.geocodeAddressString(query) { (places, error) -> Void in
            //dest map item:
            let dest = MKPlacemark(placemark: places!.first!)
            let destMapItem = MKMapItem(placemark: dest)
            
            //start map item:
            let startItem = MKMapItem.mapItemForCurrentLocation()
            
            //request
            let request = MKDirectionsRequest()
            request.source = startItem
            request.destination = destMapItem
            request.transportType = .Automobile
            
            request.requestsAlternateRoutes = false
            
            //use the request to get instructions
            let directions = MKDirections(request: request)
            directions.calculateDirectionsWithCompletionHandler({ (response, error) -> Void in
                let route = response!.routes[0]
                for step in route.steps{
                    print(step.instructions)
                }
            })
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        //print(error)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways{
            //print("Yay")
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
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(PizaaAnnotiation){
            let annotationView = MKAnnotationView()
            annotationView.annotation = annotation
            // annotationView.pinTintColor = UIColor.purpleColor()
            annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            
            annotationView.image = UIImage(named: "piz")
            annotationView.canShowCallout = true
            return annotationView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //print("Tapped")
        let url = NSURL(string: "https://github.com/HackeruIOS2016/MapKitDemos")!
        if UIApplication.sharedApplication().canOpenURL(url){
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
}
