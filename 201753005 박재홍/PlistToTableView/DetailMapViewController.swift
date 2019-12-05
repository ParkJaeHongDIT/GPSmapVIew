import UIKit
import MapKit
import CoreLocation

class DetailMapViewController: UIViewController,CLLocationManagerDelegate {
    
    var dTitle: String?
    var dAddress: String?
    
    
    @IBOutlet weak var detailMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var locationManager = CLLocationManager()
        
        //GPS 트래킹   CLLocationManager를 이용하여 현재 나의 위치 표시
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        detailMapView.showsUserLocation = true
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let userLocation = locations[0]
            
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude:userLocation.coordinate.latitude,
                                               longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
            )
            
            detailMapView.setRegion(region, animated: true)
            
        }
        
        print("dTitle = \(String(describing: dTitle))")
        print("dAddress = \(String(describing: dAddress))")
        
        // navigation title 설정
        self.title = dTitle
        
        
        // geoCoding 위도와 경도의 좌표값를 얻는 것
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(dAddress!, completionHandler: { plackmarks, error in
            
            if error != nil {
                print(error!)
            }
            
            if plackmarks != nil {
                let myPlacemark  = plackmarks?[0]
                
                if (myPlacemark?.location) != nil {
                    let myLat = myPlacemark?.location?.coordinate.latitude
                    let myLong = myPlacemark?.location?.coordinate.longitude
                    let center = CLLocationCoordinate2DMake(myLat!, myLong!)
                    let span = MKCoordinateSpanMake(0.3, 0.3)
                    let region = MKCoordinateRegionMake(center, span)
                    self.detailMapView.setRegion(region, animated: true)
                    
                    // 지도에 핀을 꼽아 타이틀과 서브타이틀이 표시
                    let anno = MKPointAnnotation()
                    anno.title = self.dTitle
                    anno.subtitle = self.dAddress
                    anno.coordinate = (myPlacemark?.location?.coordinate)!
                    self.detailMapView.addAnnotation(anno)
                    self.detailMapView.selectAnnotation(anno, animated: true)
                }
            }
            
        } ) //geoCoding
        

        
    }
    
}
