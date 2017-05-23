//
//  ViewController.swift
//  neighborhood watch
//
//  Created by Eli Berger on 5/20/17.
//
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase


class ViewController: UIViewController, CLLocationManagerDelegate{

    
    
    @IBOutlet var mapView: MKMapView!
    
    let manager = CLLocationManager()
    
    var ref: DatabaseReference!
    var refHandle: UInt!
    var timer: Timer!
    var refresher: UIRefreshControl!
    let categories = ["Blocked Roads", "Crowd", "Infrastructure", "Sanitation", "Suspicious Activity"]
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated:true)
        
        self.mapView.showsUserLocation = true
    }
    
    func checkPinStatus(inputTimestamp:TimeInterval) -> (Bool){
        let date1:Date = Date()
        let date2:Date = Date(timeIntervalSince1970: inputTimestamp)
        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.minute, .day, .hour], from: date2, to: date1)
        print(components)
        //if components.hour! >= 6
        if (components.minute! >= 1 || components.day! >= 1 || components.hour! >= 1){
            return false
        }
        return true
    }
    
    func update() {
        // Get data from the firebase
        self.mapView.removeAnnotations(self.mapView.annotations)
        ref = Database.database().reference()
        for items in categories {
            ref.child(items).observe(.childAdded, with: { (snapshot) in
                let enumerator = snapshot.children
                var array: [Any] = []
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    array.append(rest.value!)
                }
                print(array)
                let pinDescription = array[0]
                let pinLongitude = array[3]
                let pinLatitude = array[2]
                let pinTimeStamp = array[4]
                let newPin = Location(title: items, locationName: pinDescription as! String, discipline: "discipline", coordinate: CLLocationCoordinate2D(latitude: pinLatitude as! CLLocationDegrees, longitude: pinLongitude as! CLLocationDegrees))
                //print(self.checkPinStatus(inputTimestamp: pinTimeStamp as! TimeInterval))
                if (self.checkPinStatus(inputTimestamp: pinTimeStamp as! TimeInterval)){
                    self.mapView.addAnnotation(newPin)
                }
            }, withCancel: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Refreshing the page every 15 seconds
        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

