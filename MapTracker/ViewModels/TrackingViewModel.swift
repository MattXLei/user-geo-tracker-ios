import Foundation
import CoreLocation
import UIKit
import Combine

@MainActor
final class TrackingViewModel: ObservableObject {
    @Published var isTracking = false
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
            coreLocationService.stop()
            isTracking = false
        } else {
            coreLocationService.start { [weak self] location in
                self?.handleLocationUpdate(location)
            }
            isTracking = true
        }
    }
    
    func refreshMap() {
        Task {
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
    }
    
    func handleLocationUpdate(_ location: CLLocation) {
        guard shouldAccept(location) else { return }

        let point = LocationPoint(
            id: self.userId,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
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
        Task.detached { [locationService, userId] in
            try? await locationService.sendLocation(
                point,
                userId: userId
            )
        }
    }
    
    private func shouldAccept(_ location: CLLocation) -> Bool {
        guard let last = locationHistory.last else { return true }

        let distance = location.distance(from: CLLocation(
            latitude: last.latitude,
            longitude: last.longitude
        ))

        let timeDelta = location.timestamp.timeIntervalSince(last.timestamp)

        return distance > 5 && timeDelta > 5
    }
}
