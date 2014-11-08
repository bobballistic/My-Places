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
        
        //------------------------Core Location -------------------------
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //------------------------Core Location -------------------------

        if activePlace == -1 {
        // --------- If user wants to add location -----------
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        } else {
        
        println(places[activePlace]["latitude"])
        println(activePlace)

        //------------------ Map and preset location --------------------
        
        let theSpan = MKCoordinateSpanMake(0.01, 0.01)
        // import lat and long from places at index activePlace, convert from sting to double
        let lat = NSString(string: places[activePlace]["latitude"]!).doubleValue
        let lon = NSString(string: places[activePlace]["longitude"]!).doubleValue
            
    
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let theRegion = MKCoordinateRegionMake(location, theSpan)
        myMap.setRegion(theRegion, animated: true)
        
            // ----------------------------- Anotation ---------------------
            
        var anotation = MKPointAnnotation()
        anotation.coordinate = location
        anotation.title = places[activePlace]["name"]
        myMap.addAnnotation(anotation)
            
            
            
        }
        
        // -------------------Long Press Gesture Implementation -----------
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "action:")
        longPress.minimumPressDuration = 1.0
        myMap.addGestureRecognizer(longPress)

        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func action(gestureRecognizer:UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began { // the gestRec does on touch and after so we check is it has just began" in order
                                                                        // to not get duplicates in array on gesture has finnished
        
            var touchPoint = gestureRecognizer.locationInView(self.myMap)
        var newCoord:CLLocationCoordinate2D = myMap.convertPoint(touchPoint, toCoordinateFromView: self.myMap)
        
        var newAnotation = MKPointAnnotation()
        newAnotation.coordinate = newCoord
        newAnotation.title = "New Location"
        myMap.addAnnotation(newAnotation)
        
        var loc = CLLocation(latitude: newCoord.latitude, longitude: newCoord.longitude)
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks, error)->Void in
            if error != nil {println(error)}
            else {
                
                let p = CLPlacemark(placemark: placemarks?[0] as CLPlacemark)
                var subThoroughfare = ""
                var thoroughfare = ""
                var subLocality = ""
                var subAdministrativeArea = ""
                if (p.subThoroughfare? != nil) {
                    subThoroughfare = p.subThoroughfare
                } else {
                    subThoroughfare = ""
                }
                
                if (p.thoroughfare? != nil) {
                    thoroughfare = p.thoroughfare
                } else {
                    thoroughfare = ""
                }
                
                if (p.subLocality != nil) {
                    subLocality = p.subLocality
                } else {
                    subLocality = ""
                }
                
                if (p.subAdministrativeArea != nil) {
                    subAdministrativeArea = p.subAdministrativeArea
                } else {
                    subAdministrativeArea = ""
                }
                
               
                
                var title = "\(subThoroughfare) \(thoroughfare)"
                if title == " " {
                    
                    var date = NSDate()
                    newAnotation.title = "Added \(date)"
                    
                }
                var subtitle = "\(subLocality) \(subAdministrativeArea)"
                
                var newAnotation = MKPointAnnotation()
                newAnotation.coordinate = newCoord
                newAnotation.title = title
                newAnotation.subtitle = subtitle
                self.myMap.addAnnotation(newAnotation)
                
                // ADD TO ARRAY
                
                var latToSendToDict = newCoord.latitude
                var lonToSendToDict = newCoord.longitude
                
                var persistentPlaces = places
                places.append(["name":title, "lat":"\(newCoord.latitude)", "lon":"\(newCoord.longitude)"])

                //MARK:- SavingToMemory
                
                NSUserDefaults.standardUserDefaults().setObject(persistentPlaces, forKey: "name")
                NSUserDefaults.standardUserDefaults().synchronize() 
                println(NSUserDefaults.standardUserDefaults().objectForKey("name"))
                //MARK
                
                
            }
            
            
            
        })

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

