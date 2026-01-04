import CoreLocation

final class DefaultCoreLocationService: NSObject, CoreLocationService, CLLocationManagerDelegate {

    private let manager = CLLocationManager()
    private var updateHandler: ((CLLocation) -> Void)? // Pipe from CoreLocationService to TrackingViewModel
    var isRunning: Bool = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func start(updating handler: @escaping (CLLocation) -> Void) {
        self.updateHandler = handler
        self.isRunning = true
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func stop() {
        self.isRunning = false
        manager.stopUpdatingLocation()
        updateHandler = nil
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }
        updateHandler?(location)
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Location error:", error.localizedDescription)
    }
}
