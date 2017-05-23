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
        if components.minute! >= 15{
            return false
        }
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
<<<<<<< HEAD
//        refHandle = ref.observe(DataEventType.value , with: {(snapshot) in
//            
//            let dataDict = snapshot.value as! [String : AnyObject]
//            print(dataDict)
//            let enumerator = snapshot.children
//            while let rest = enumerator.nextObject() as? DataSnapshot {
//                print(rest.value)
//            }
//        }
=======

        let categories = ["Blocked Roads", "Crowd", "Infrastructure", "Sanitation", "Suspicious Activity"]
>>>>>>> cfca825ccac542f04df29a58032fc656db8e7fdb
        for items in categories {
        ref.child(items).observe(.childAdded, with: { (snapshot) in
            let enumerator = snapshot.children
            var array: [Any] = []
            while let rest = enumerator.nextObject() as? DataSnapshot {
                        array.append(rest.value!)
                        }
<<<<<<< HEAD
//          print(snapshot)
            print(array)
            let pinDescription = array[0]
            let pinLongitude = array[3]
            let pinLatitude = array[2]
            let pinTimeStamp = array[4]
            
            if (self.checkPinStatus(inputTimestamp: pinTimeStamp as! TimeInterval)){
              let newPin = Location(title: items, locationName: pinDescription as! String, discipline: "discipline", coordinate: CLLocationCoordinate2D(latitude: pinLatitude as! CLLocationDegrees, longitude: pinLongitude as! CLLocationDegrees))
              self.mapView.addAnnotation(newPin)
=======
              print(array)
              var pinDescription = array[0]
              var pinLongitude = array[3]
              var pinLatitude = array[2]
            var pinTimeStamp = array[4]
            if (self.checkPinStatus(inputTimestamp: pinTimeStamp as! TimeInterval)){
            let newPin = Location(title: items,
                locationName: pinDescription as! String,
                discipline: items,
                coordinate: CLLocationCoordinate2D(latitude: pinLatitude as! CLLocationDegrees, longitude: pinLongitude as! CLLocationDegrees))
            self.mapView.addAnnotation(newPin)
>>>>>>> cfca825ccac542f04df29a58032fc656db8e7fdb
            }
          }, withCancel: nil)
        }
        
        //let initialLocation = CLLocation(latitude: 37.784633, longitude: -122.397414)
        
        //let regionRadius: CLLocationDistance = 1000
        
        //func centerMapOnLocation(location: CLLocation) {
         //   let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
          //                                                            regionRadius * 2.0, regionRadius * 2.0)
          //  mapView.setRegion(coordinateRegion, animated: true)
        //}
        
<<<<<<< HEAD
        //centerMapOnLocation(location: initialLocation)
        mapView.delegate = self 
=======
        centerMapOnLocation(location: initialLocation)
        mapView.delegate = self

>>>>>>> cfca825ccac542f04df29a58032fc656db8e7fdb
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

<<<<<<< HEAD
        // can also use
        // snapshot.childSnapshotForPath("full_name").value as! String
        
        // show artwork on map
        //let location2 = Location(title: "DevBootcamp",
        //locationName: "633 Folsom Street",
        //discipline: "Sculpture",
        //coordinate: CLLocationCoordinate2D(latitude: 37.784633, longitude: -122.397414))
        
        //mapView.addAnnotation(location2)
=======
        
>>>>>>> cfca825ccac542f04df29a58032fc656db8e7fdb
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

