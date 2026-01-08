import XCTest
import CoreLocation
@testable import MapTracker

@MainActor
final class LocationUpdateTests: XCTestCase {

    private var viewModel: TrackingViewModel!
    private var fakeCoreLocationService: FakeCoreLocationService!

    override func setUp() {
        super.setUp()

        fakeCoreLocationService = FakeCoreLocationService()

        viewModel = TrackingViewModel(
            userId: "test-user",
            coreLocationService: fakeCoreLocationService
        )
    }

    func testLastLocationUpdatesOnLocationCallback() {
        viewModel.toggleTracking()
        fakeCoreLocationService.emit(
            latitude: 37.7749,
            longitude: -122.4194
        )

        XCTAssertNotNil(viewModel.lastLocation)
        XCTAssertEqual(
            viewModel.lastLocation?.coordinate.latitude ?? -1,
            37.7749,
            accuracy: 0.0001
        )
    }
}
