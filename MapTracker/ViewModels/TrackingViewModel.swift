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
    
    // DEPRECATED: Using MapKit instead of Python backend
    // private let locationService: LocationService
    // @Published var mapImage: UIImage?
    // @Published var errorMessage: String?

    private let userId: String
    private let coreLocationService: CoreLocationService

    init(
        userId: String,
        coreLocationService: CoreLocationService,
    ) {
        self.userId = userId
        self.coreLocationService = coreLocationService
    }
    
    // Alternative init for backwards compatibility if LocationService is restored
    /*
    init(
        userId: String,
        locationService: LocationService,
        coreLocationService: CoreLocationService,
    ) {
        self.userId = userId
        self.locationService = locationService
        self.coreLocationService = coreLocationService
    }
    */

    func toggleTracking() {
        if coreLocationService.isRunning {
            isTracking = false
            coreLocationService.stop()
        } else {
            isTracking = true
            coreLocationService.start(updating: handleLocationUpdate)
        }
    }
    
    // DEPRECATED: Python backend map image fetching - keeping for reference
    // Use MapKit instead for interactive map
    /*
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
    */
    
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
    
    // DEPRECATED: Python backend API call removed - using MapKit for local visualization
    // To restore backend integration, uncomment below and add locationService back to init
    /*
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
    */
    
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
