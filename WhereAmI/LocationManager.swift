//
//
//  LocationManager
//  WhereAmI
//
//  Created by Dan Hart on 1/9/20.
//

import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let manager: CLLocationManager
    private let geocoder = CLGeocoder()
    
    var didChange = PassthroughSubject<LocationManager, Never>()
    let objectWillChange = PassthroughSubject<Void, Never>()

    @Published var placemark: CLPlacemark? {
      willSet { objectWillChange.send() }
    }
    
    var lastKnownLocation: CLLocation? {
        didSet {
            didChange.send(self)
        }
    }
    
    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        super.init()
        
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
    }

    private func geocode() {
        guard let location = self.lastKnownLocation else { return }
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
            if error == nil {
                self.placemark = places?[0]
            } else {
                self.placemark = nil
            }
        })
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.last
        self.geocode()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
}
