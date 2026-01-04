import CoreLocation
@testable import MapTracker

final class FakeCoreLocationService: CoreLocationService {

    private var updateHandler: ((CLLocation) -> Void)?
    private(set) var isRunning: Bool = false

    func start(updating handler: @escaping (CLLocation) -> Void) {
        self.updateHandler = handler
        isRunning = true
    }

    func stop() {
        isRunning = false
        updateHandler = nil
    }

    func emit(
        latitude: Double,
        longitude: Double,
        timestamp: Date = Date()
    ) {
        guard isRunning else { return }

        let location = CLLocation(
            coordinate: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            ),
            altitude: 0,
            horizontalAccuracy: 5,
            verticalAccuracy: 5,
            timestamp: timestamp
        )

        updateHandler?(location)
    }
}
