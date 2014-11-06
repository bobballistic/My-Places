//
//  ViewController.swift
//  MyPlaces
//
//  Created by Bob on 05/11/2014.
//  Copyright (c) 2014 BallisticSoft. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var myMap: MKMapView!
    var manager = CLLocationManager()

  
    
    @IBAction func findMe(sender: AnyObject) {
        
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    
    }
   
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        let latitudeByLocation = userLocation.coordinate.latitude
        let longitudeByLocation = userLocation.coordinate.longitude
        
        let theSpanCore:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let locationCore:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitudeByLocation, longitude: longitudeByLocation)
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(locationCore, theSpanCore)
        myMap.setRegion(theRegion, animated: true)
        manager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Failed with error \(error)")
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // ------------- Keep the navigation controler after the back button is hit ------------------
        if segue.identifier == "back" {
            self.navigationController?.navigationBarHidden = false
        }
    }
    
    override func viewDidLoad() {
        println(places[activePlace]["latitude"])
        println(activePlace)
       
        //------------------------Core Location -------------------------
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
       
        
        //------------------ Map and preset location --------------------
        
        let theSpan = MKCoordinateSpanMake(0.01, 0.01)
        // import lat and long from places at index activePlace, convert from sting to double
        let lat = NSString(string: places[activePlace]["latitude"]!).doubleValue
        let lon = NSString(string: places[activePlace]["longitude"]!).doubleValue
    
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let theRegion = MKCoordinateRegionMake(location, theSpan)
        myMap.setRegion(theRegion, animated: true)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

