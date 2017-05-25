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
    internal var upvoteCount = false
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
    
    func checkPinStatus(inputTimestamp:TimeInterval, voteCount:Int) -> (Bool){
        let date1:Date = Date()
        let date2:Date = Date(timeIntervalSince1970: inputTimestamp)
        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.minute, .day, .hour], from: date2, to: date1)
        if (voteCount > 0 && components.day! >= 1){
            return false
        }
        else if (voteCount == 0 && components.hour! >= 6){
            return false
        }
        else if (voteCount < 0 && voteCount > -5 && components.minute! >= 30){
            return false
        }
        else if(voteCount < -5 && voteCount > -10){
            return false
        }
        return true
    }
    
    func update() {
        // Get data from the firebase
        self.mapView.removeAnnotations(self.mapView.annotations)
        showPin()
    }
    
    func logoutButton(){
        if (UserDefaults.standard.value(forKey: "isLoggedIn") as! Bool == true){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.handleLogout))
        }
    }
    
    func showPin(){
        logoutButton()
        ref = Database.database().reference()
        for items in categories {
            ref.child(items).observe(.childAdded, with: { (snapshot) in
                let enumerator = snapshot.children

                let pinID = snapshot.key
                var array: [Any] = [pinID]
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    array.append(rest.value!)
                }
                let pinIdInDatabase = array[0]
                let pinDescription = array[1]
                let pinLongitude = array[4]
                let pinLatitude = array[3]
                let pinTimeStamp = array[5]
                let pinVote = array[6]
                let newPin = Location(title: items, locationName: pinDescription as! String, discipline: items, coordinate: CLLocationCoordinate2D(latitude: pinLatitude as! CLLocationDegrees, longitude: pinLongitude as! CLLocationDegrees), pinKey: pinIdInDatabase as! String)
                if (self.checkPinStatus(inputTimestamp: pinTimeStamp as! TimeInterval, voteCount: pinVote as! Int )){
                    self.mapView.addAnnotation(newPin)
                }
            }, withCancel: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showPin()
        ref = Database.database().reference()
        Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func handleLogout() {
       UserDefaults.standard.set(false, forKey: "isLoggedIn")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.navigationItem.setLeftBarButton(nil, animated: false)
    }
    
    @IBAction func addPinTapped(_ sender: UIButton) {
        moveToCreatePinVC()
    }
    
    private func moveToCreatePinVC() {
        if (UserDefaults.standard.value(forKey: "isLoggedIn") as! Bool == true) {
            let pinVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PinVC") as! CreatePinViewController
            self.navigationController?.pushViewController(pinVC, animated: true)
        } else {
            let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! SecondViewController
            loginVC.navigationController = self.navigationController
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
}

