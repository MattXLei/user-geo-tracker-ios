import SwiftUI

@main
struct MapTrackerApp: App {
    private let userId = "demo-user"
    private let backendURL = URL(string: "http://10.0.0.135:8000")! //"http://127.0.0.1:8000")!

    private let locationService: LocationService
    private let coreLocationService: CoreLocationService

    init() {
        self.locationService = LocationAPIService(baseURL: backendURL)
        self.coreLocationService = DefaultCoreLocationService()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                userId: userId,
                locationService: locationService,
                coreLocationService: coreLocationService
            )
        }
    }
}
