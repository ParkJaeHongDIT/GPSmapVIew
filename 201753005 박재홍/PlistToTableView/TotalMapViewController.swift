import UIKit
import MapKit
import CoreLocation

class TotalMapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var totalMapView: MKMapView!
    var dContents: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var locationManager = CLLocationManager()
        
        //GPS 트래킹   CLLocationManager를 이용하여 현재 나의 위치 표시
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        totalMapView.showsUserLocation = true
        
        // 현재 위치가 업데이트 될 때마다 내위치가 중간에 있도록 표시
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let userLocation = locations[0]
            
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude:userLocation.coordinate.latitude,
                                               longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
            )
            
            totalMapView.setRegion(region, animated: true)
            
        }
        
        
        print("dContents = \(String(describing: dContents))")
        
        
        //배열을 선언하여 Add.plist의 데이터를 배열에 담아서 지도에 넘겨줌
        var annos = [MKPointAnnotation]()
        
        if let myItems = dContents {
            for item in myItems {
                let address = (item as AnyObject).value(forKey: "address")
                let title = (item as AnyObject).value(forKey: "title")
                let geoCoder = CLGeocoder()
                
                geoCoder.geocodeAddressString(address as! String, completionHandler: { placemarks, error in
                    if error != nil {
                        print(error!)
                        return
                    }
                    //받아온 데이터들을 지도에 핀을 꼽아 표시
                    if let myPlacemarks = placemarks {
                        let myPlacemark = myPlacemarks[0]
                        
                        let anno = MKPointAnnotation()
                        anno.title = title as? String
                        anno.subtitle = address as? String
                        
                        if let myLocation = myPlacemark.location {
                            anno.coordinate = myLocation.coordinate
                            annos.append(anno)
                        }
                        
                    }
                    
                    self.totalMapView.showAnnotations(annos, animated: true)
                    self.totalMapView.addAnnotations(annos)
                } )
            }
            
        } else {
            print("nil")
        }
        
    }
    
    // MKMapViewDelegate method
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myPin"
        
        // an already allocated annotation view
        var annotationView = totalMapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            //annotationView?.pinTintColor = UIColor.green
            annotationView?.animatesDrop = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
        
    }
    
    // callout accessary를 눌렀을때 alert View 보여줌
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        present(.getInfo(((view.annotation?.title)!)!), animated: true, completion:nil)
        let viewAnno = view.annotation //as! ViewPoint
        let placeName = viewAnno?.title
        let placeInfo = viewAnno?.subtitle
        
        let ac = UIAlertController(title: placeName!, message: placeInfo!, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
}
