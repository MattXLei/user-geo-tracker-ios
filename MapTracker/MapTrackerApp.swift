import SwiftUI

@main
struct MapTrackerApp: App {
    private let userId = "demo-user"

    private let coreLocationService: CoreLocationService

    init() {
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
