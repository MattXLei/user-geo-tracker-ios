import XCTest
import CoreLocation
@testable import MapTracker

@MainActor
final class LocationHistoryTests: XCTestCase {

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
            coreLocationService: fakeCoreLocationService,
        )
    }

    func testFirstLocationIsAccepted() {
        let now = Date()
        viewModel.toggleTracking()

        fakeCoreLocationService.emit(
            latitude: 37.0,
            longitude: -122.0,
            timestamp: now
        )

        XCTAssertEqual(viewModel.locationHistory.count, 1)
    }

    func testDuplicateLocationIsRejected() {
        let now = Date()
        viewModel.toggleTracking()

        fakeCoreLocationService.emit(
            latitude: 37.0,
            longitude: -122.0,
            timestamp: now
        )

        fakeCoreLocationService.emit(
            latitude: 37.0,
            longitude: -122.0,
            timestamp: now.addingTimeInterval(1)
        )

        XCTAssertEqual(viewModel.locationHistory.count, 1)
    }

    func testLocationFarEnoughIsAccepted() {
        let now = Date()
        viewModel.toggleTracking()

        fakeCoreLocationService.emit(
            latitude: 37.0,
            longitude: -122.0,
            timestamp: now
        )

        fakeCoreLocationService.emit(
            latitude: 37.0002,
            longitude: -122.0002,
            timestamp: now.addingTimeInterval(10)
        )

        XCTAssertEqual(viewModel.locationHistory.count, 2)
    }
}
