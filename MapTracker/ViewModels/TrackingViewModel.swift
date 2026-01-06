import Foundation
import CoreLocation
import UIKit
import Combine

@MainActor
final class TrackingViewModel: ObservableObject {
    @Published var isTracking = false
    @Published var errorMessage: String?
    @Published var lastLocation: CLLocation?
    @Published private(set) var locationHistory: [LocationPoint] = []
    @Published var mapImage: UIImage?

    private let userId: String
    private let locationService: LocationService
    private let coreLocationService: CoreLocationService

    init(
        userId: String,
        locationService: LocationService,
        coreLocationService: CoreLocationService,
    ) {
        self.userId = userId
        self.locationService = locationService
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
    
    @MainActor
    func refreshMap() async {
        do {
            let data = try await locationService.fetchMapImage(userId: userId)

            guard let image = UIImage(data: data) else {
                print("Failed to decode map image")
                return
            }
            
            self.mapImage = image
        } catch {
            print("Map fetch failed:", error)
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
        send(point: point)
    }
    
    @MainActor
    private func apply(point: LocationPoint, location: CLLocation) {
        self.lastLocation = location
        self.locationHistory.append(point)
    }
    
    private func send(point: LocationPoint) {
        Task { [locationService, userId] in
            do {
                try await locationService.sendLocation(point, userId: userId)
                await refreshMap()
            } catch {
                self.errorMessage = "Failed to sync location. Check your connection."
            }
        }
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
