import XCTest
import CoreLocation
@testable import MapTracker

@MainActor
final class TrackingViewModelTests: XCTestCase, Sendable {
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

    func testToggleTrackingStartsAndStopsLocationService() {
        XCTAssertFalse(fakeCoreLocationService.isRunning)

        viewModel.toggleTracking()
        XCTAssertTrue(fakeCoreLocationService.isRunning)

        viewModel.toggleTracking()
        XCTAssertFalse(fakeCoreLocationService.isRunning)
    }

    func testFirstLocationIsAlwaysAccepted() {
        let expectation = expectation(description: "Location sent to backend")
        fakeLocationService.onSend = {
            expectation.fulfill()
        }
        
        let timestamp = Date()

        let location = CLLocation(
            coordinate: CLLocationCoordinate2D(
                latitude: 33.0,
                longitude: -84.0
            ),
            altitude: 0,
            horizontalAccuracy: 5,
            verticalAccuracy: 5,
            timestamp: timestamp
        )

        viewModel.handleLocationUpdate(location)
        XCTAssertEqual(viewModel.locationHistory.count, 1)

        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(fakeLocationService.sentPoints.count, 1)

        let point = fakeLocationService.sentPoints.first!
        XCTAssertEqual(point.latitude, 33.0)
        XCTAssertEqual(point.longitude, -84.0)
        XCTAssertEqual(point.timestamp, timestamp)
    }

    func testLocationRejectedWhenTooCloseAndTooSoon() {
        let expectation = expectation(description: "Only 1 Location Kept")
        fakeLocationService.onSend = {
            expectation.fulfill()
        }
        
        let start = Date()
        
        viewModel.toggleTracking()
        fakeCoreLocationService.emit(
            latitude: 33.0,
            longitude: -84.0,
            timestamp: start
        )

        fakeCoreLocationService.emit(
            latitude: 33.00001, // ~1m
            longitude: -84.00001,
            timestamp: start.addingTimeInterval(2)
        )

        XCTAssertEqual(self.viewModel.locationHistory.count, 1)
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(self.fakeLocationService.sentPoints.count, 1)
    }

    func testLocationAcceptedWhenDistanceAndTimeThresholdsMet() {
        let expectation = expectation(description: "2 Locations Added")
        expectation.expectedFulfillmentCount = 2
        fakeLocationService.onSend = {
            expectation.fulfill()
        }
        
        let start = Date()
        
        viewModel.toggleTracking()
        fakeCoreLocationService.emit(
            latitude: 33.0,
            longitude: -84.0,
            timestamp: start
        )

        fakeCoreLocationService.emit(
            latitude: 33.001, // ~111m
            longitude: -84.001,
            timestamp: start.addingTimeInterval(10)
        )

        XCTAssertEqual(self.viewModel.locationHistory.count, 2)
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(self.fakeLocationService.sentPoints.count, 2)
    }
}
