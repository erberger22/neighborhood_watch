import MapKit

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
                
                print("MIKE: annotation image \(annotation.image)")
                // 3
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                let confirmButton = UIButton(type: .system) as UIButton
                confirmButton.frame.size.width = 55
                confirmButton.frame.size.height = 24
                confirmButton.setTitle("Confirm", for: .normal)
                confirmButton.setTitleColor(.blue, for: .normal)
                view.leftCalloutAccessoryView = confirmButton
                return view
            
           }
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
//        print("*********************")
//        print("view annotation")
//        print(view.annotation!.coordinate)
//        print(view.annotation!.pinKey)
//        print("*********************")
        
        if control == view.rightCalloutAccessoryView{
            let location = view.annotation as! Location
            let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMaps(launchOptions: launchOptions)
        }
        if control == view.leftCalloutAccessoryView{
            
            let location = view.annotation as! Location
            var pinKeyString = location.pinKey as! String
            createAlert(title: "Is this still here?", message: "", pinKey: pinKeyString)
            
        }
    }
    
    func createAlert (title:String, message:String, pinKey:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
//            ADD CODE IF THEY CHOOSE YES
                print("*********************")
                print(pinKey)
                print("*********************")
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
//            ADD CODE IF THEY CHOOSE NO
            print("*********************")
            print(pinKey)
            print("*********************")

        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

