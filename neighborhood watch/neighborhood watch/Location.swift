import Foundation
import MapKit
import Contacts
import AddressBook

class Location: NSObject, MKAnnotation {
    var title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    var image: UIImage {
    print("DISCIPLINE === \(discipline)")
    switch discipline {
        case "Sanitation":
    print("poop image")
            return UIImage(named: "poop_emoji")!
        case "Blocked Roads":
        print("blocked road image...")
        return UIImage(named: "road_block")!
        default:
        print("nothing")
            return UIImage()
    }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
                 calloutAccessoryControlTapped control: UIControl!) {
        let location = view.annotation as! Location
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
    
    func pinTintColor() -> UIColor  {
        switch discipline {
            case "Blocked Roads":
        return MKPinAnnotationView.redPinColor()
            case "Sculpture":
        return MKPinAnnotationView.purplePinColor()
            default:
        return MKPinAnnotationView.greenPinColor()
        }
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
    
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
    
        return mapItem
    }
    
}

