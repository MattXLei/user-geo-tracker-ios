import SwiftUI

@main
struct MapTrackerApp: App {
    private let userId = "demo-user"
    
    // DEPRECATED: Python backend no longer needed for MapKit visualization
    // private let backendURL = URL(string: "http://10.0.0.135:8000")!
    // private let locationService: LocationService

    private let coreLocationService: CoreLocationService

    init() {
        // DEPRECATED: LocationAPIService initialization removed
        // self.locationService = LocationAPIService(baseURL: backendURL)
        self.coreLocationService = DefaultCoreLocationService()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                userId: userId,
                coreLocationService: coreLocationService
            )
        }
    }
}
