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
import Firebase


class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet var mapView: MKMapView!
    
    let manager = CLLocationManager()
    internal var upvoteCount: Int?
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
        if (components.minute! >= 15 || components.day! >= 1 || components.hour! >= 1){
            return false
        }
        return true
    }
    
    func update() {
        // Get data from the firebase
        self.mapView.removeAnnotations(self.mapView.annotations)
        showPin()
    }
    
    func showPin(){
        ref = Database.database().reference()
        for items in categories {
            ref.child(items).observe(.childAdded, with: { (snapshot) in
                let enumerator = snapshot.children
//                The id of each pin that is made
                let pinID = snapshot.key
                var array: [Any] = [pinID]
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    array.append(rest.value!)
                }
//                print("***********************")
//                print(array)
//                print("***********************")
                let pinIdInDatabase = array[0]
                let pinDescription = array[1]
                let pinLongitude = array[4]
                let pinLatitude = array[3]
                let pinTimeStamp = array[5]
                let newPin = Location(title: items, locationName: pinDescription as! String, discipline: items, coordinate: CLLocationCoordinate2D(latitude: pinLatitude as! CLLocationDegrees, longitude: pinLongitude as! CLLocationDegrees), pinKey: pinIdInDatabase as! String)
                //print(self.checkPinStatus(inputTimestamp: pinTimeStamp as! TimeInterval))
                if (self.checkPinStatus(inputTimestamp: pinTimeStamp as! TimeInterval)){
                    self.mapView.addAnnotation(newPin)
                }
            }, withCancel: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showPin()
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

