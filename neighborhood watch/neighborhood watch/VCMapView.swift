import MapKit
import FirebaseDatabase

extension ViewController: MKMapViewDelegate {
    
    // 1
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Location {
            //let identifier = "pin"
            var view: MKAnnotationView
            if mapView.dequeueReusableAnnotationView(withIdentifier: annotation.subtitle!) != nil {
                view = MKAnnotationView()
                view.annotation = annotation
                view.image = annotation.image
                print("MIKE: annotation image \(annotation.image)")
                return view
            } else {
                view = MKAnnotationView()
                view.annotation = annotation
                view.image = annotation.image
                // 3
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                let confirmButton = UIButton(type: .system) as UIButton
                confirmButton.frame.size.width = 55
                confirmButton.frame.size.height = 24
                confirmButton.setTitle("Confirm", for: .normal)
                confirmButton.setTitleColor(.blue, for: .normal)
                if (UserDefaults.standard.value(forKey: "isLoggedIn") as! Bool == true){
                  view.leftCalloutAccessoryView = confirmButton
                }
                return view
           }
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            let location = view.annotation as! Location
            let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMaps(launchOptions: launchOptions)
        }
        if control == view.leftCalloutAccessoryView{
            let location = view.annotation as! Location
            let pinKeyString = location.pinKey!
            let pinTitle = location.title!
            let alert = createAlert(title: "Is this still here?", message: "", pinKey: pinKeyString, pinCategory: pinTitle)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func createAlert (title:String, message:String, pinKey:String, pinCategory:String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            var _ = self.ref.child(pinCategory).child(pinKey).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if let snapshot = snapshot.value as? [String: Any?] {
                    guard let count = snapshot["zConformation"] as? Int else { return }
                    self.ref.child(pinCategory).child(pinKey).updateChildValues(["zConformation": count + 1])
                    self.upvoteCount = true
                    return
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            var _ = self.ref.child(pinCategory).child(pinKey).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                //print("Hello, World!")
                if let snapshot = snapshot.value as? [String: Any?] {
                    guard let count = snapshot["zConformation"] as? Int else { return }
                    self.ref.child(pinCategory).child(pinKey).updateChildValues(["zConformation": count - 1])
                    self.upvoteCount = true
                    return
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }))
        return alert
    }
}

