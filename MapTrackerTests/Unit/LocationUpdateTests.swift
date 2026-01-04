import XCTest
import CoreLocation
@testable import MapTracker

@MainActor
final class LocationUpdateTests: XCTestCase {

    private var viewModel: TrackingViewModel!
    private var fakeLocationService: FakeLocationService!
    private var fakeCoreLocationService: FakeCoreLocationService!

    override func setUp() {
        super.setUp()

        fakeLocationService = FakeLocationService()
        fakeCoreLocationService = FakeCoreLocationService()

        viewModel = TrackingViewModel(
            userId: "test-user",
            locationService: fakeLocationService,
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
