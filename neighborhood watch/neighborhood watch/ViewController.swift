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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated:true)
        
        self.mapView.showsUserLocation = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        refHandle = ref.observe(DataEventType.value , with: {(snapshot) in
            let dataDict = snapshot.value as! [String : AnyObject]
            print(dataDict)
        })
        
        let initialLocation = CLLocation(latitude: 37.784633, longitude: -122.397414)
        
        let regionRadius: CLLocationDistance = 1000
        
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
        centerMapOnLocation(location: initialLocation)
        //mapView.delegate = self

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

        
        
        // can also use
        // snapshot.childSnapshotForPath("full_name").value as! String
        
        // show artwork on map
        //let location2 = Location(title: "DevBootcamp",
        //locationName: "633 Folsom Street",
        //discipline: "Sculpture",
        //coordinate: CLLocationCoordinate2D(latitude: 37.784633, longitude: -122.397414))
        
        //mapView.addAnnotation(location2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

