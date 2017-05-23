import MapKit

extension ViewController: MKMapViewDelegate {
    
    // 1
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Location {
            let identifier = "pin"
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
                return view
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Location
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}

