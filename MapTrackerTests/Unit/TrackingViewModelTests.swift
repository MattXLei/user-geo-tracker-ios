import XCTest
import CoreLocation
@testable import MapTracker

@MainActor
final class TrackingViewModelTests: XCTestCase, Sendable {
    private var viewModel: TrackingViewModel!
    private var fakeCoreLocationService: FakeCoreLocationService!
    
    override func setUp() {
        super.setUp()
        
        fakeCoreLocationService = FakeCoreLocationService()
        
        viewModel = TrackingViewModel(
            userId: "test-user",
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
        
        viewModel.toggleTracking()
        viewModel.handleLocationUpdate(location)
        XCTAssertEqual(viewModel.locationHistory.count, 1)
        
        let point = viewModel.locationHistory.first!
        XCTAssertEqual(point.lat, 33.0)
        XCTAssertEqual(point.lon, -84.0)
        XCTAssertEqual(point.timestamp, timestamp)
    }
    
    func testLocationRejectedWhenTooCloseAndTooSoon() {
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
    }
    
    func testLocationAcceptedWhenDistanceAndTimeThresholdsMet() {
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
    }
    
    // DEPRECATED: Map image refresh test - now using MapKit for visualization
    // Keeping test structure for reference if Python backend is restored
    /*
     func testRefreshMapAppliesFetchedImage() async throws {
     let renderer = UIGraphicsImageRenderer(size: CGSize(width: 10, height: 10))
     let image = renderer.image { ctx in
     UIColor.red.setFill()
     ctx.fill(CGRect(x: 0, y: 0, width: 10, height: 10))
     }
     
     fakeLocationService.mapImageData = image.pngData()
     
     await viewModel.refreshMap()
     let mapImage = try XCTUnwrap(viewModel.mapImage)
     
     XCTAssertGreaterThan(mapImage.size.width, 0)
     XCTAssertGreaterThan(mapImage.size.height, 0)
     }
     */
    
    // MapKit-based tests
    func testSelectLocationUpdatesSelectedLocation() {
        let point = LocationPoint(
            id: "test-id",
            lat: 33.0,
            lon: -84.0,
            timestamp: Date()
        )
        
        viewModel.selectLocation(point)
        XCTAssertEqual(viewModel.selectedLocation?.id, point.id)
    }
    
    func testDeselectLocationClearsSelection() {
        let point = LocationPoint(
            id: "test-id",
            lat: 33.0,
            lon: -84.0,
            timestamp: Date()
        )
        
        viewModel.selectLocation(point)
        XCTAssertNotNil(viewModel.selectedLocation)
        
        viewModel.deselectLocation()
        XCTAssertNil(viewModel.selectedLocation)
    }
}
