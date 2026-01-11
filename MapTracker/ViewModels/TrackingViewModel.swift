import Foundation
import CoreLocation
import UIKit
import MapKit
import Combine

@MainActor
final class TrackingViewModel: ObservableObject {
    @Published var isTracking = false
    @Published var lastLocation: CLLocation?
    @Published private(set) var locationHistory: [LocationPoint] = []
    @Published var selectedLocation: LocationPoint?

    private let userId: String
    private let coreLocationService: CoreLocationService

    init(userId: String, coreLocationService: CoreLocationService) {
        self.userId = userId
        self.coreLocationService = coreLocationService
    }

    func toggleTracking() {
        if coreLocationService.isRunning {
            isTracking = false
            coreLocationService.stop()
        } else {
            isTracking = true
            coreLocationService.start(updating: handleLocationUpdate)
        }
    }
    
    func handleLocationUpdate(_ location: CLLocation) {
        guard isTracking else { return }
        guard shouldAccept(location) else { return }
        
        let point = LocationPoint(
            id: self.userId,
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude,
            timestamp: location.timestamp
        )

        apply(point: point, location: location)
    }
    
    @MainActor
    private func apply(point: LocationPoint, location: CLLocation) {
        self.lastLocation = location
        self.locationHistory.append(point)
    }
    
    func selectLocation(_ point: LocationPoint) {
        self.selectedLocation = point
    }
    
    func deselectLocation() {
        self.selectedLocation = nil
    }
    
    private func shouldAccept(_ location: CLLocation) -> Bool {
        guard let last = locationHistory.last else { return true }

        let distance = location.distance(from: CLLocation(
            latitude: last.lat,
            longitude: last.lon
        ))

        let timeDelta = location.timestamp.timeIntervalSince(last.timestamp)

        return distance > 5 && timeDelta > 0.5
    }
}
