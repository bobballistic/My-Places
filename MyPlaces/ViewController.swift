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

    override func viewDidLoad() {
        println(places[activePlace]["latitude"])
        println(activePlace)
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

