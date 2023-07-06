import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
