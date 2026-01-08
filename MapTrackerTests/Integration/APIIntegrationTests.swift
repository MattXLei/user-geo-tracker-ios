/*import XCTest
import CoreLocation
import UIKit
@testable import MapTracker

@MainActor
final class TrackingViewModelAPIIntegrationTests: XCTestCase {
    
    private var viewModel: TrackingViewModel!
    private var apiService: LocationAPIService!
    private var fakeCoreLocationService: FakeCoreLocationService!
    private var testUserId: String = ""
    
    override func setUp() async throws {
        testUserId = "integration-test-\(UUID().uuidString)"
        apiService = LocationAPIService(
            baseURL: URL(string: "http://127.0.0.1:8000")!
        )
        fakeCoreLocationService = FakeCoreLocationService()
        
        viewModel = TrackingViewModel(
            userId: testUserId,
            locationService: apiService,
            coreLocationService: fakeCoreLocationService
        )
        
        viewModel.toggleTracking()
    }
    
    override func tearDown() async throws {
        viewModel.toggleTracking()
        viewModel = nil
        apiService = nil
        fakeCoreLocationService = nil
    }
    
    func testSendLocationAndRetrieveHistory() async throws {
        let location = CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: 33.0, longitude: -84.0),
            altitude: 0,
            horizontalAccuracy: 5,
            verticalAccuracy: 5,
            timestamp: Date()
        )
        
        viewModel.handleLocationUpdate(location)
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Fetch locations directly via API
        let url = URL(string: "http://127.0.0.1:8000/locations/\(testUserId)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        struct Response: Decodable {
            let id: String
            let locations: [LocationPoint]
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let response = try decoder.decode(Response.self, from: data)
        XCTAssertEqual(response.locations.count, 1)
        
        let firstLocation = try XCTUnwrap(response.locations.first)
        XCTAssertEqual(firstLocation.lat, 33.0, accuracy: 0.0001)
        XCTAssertEqual(firstLocation.lon, -84.0, accuracy: 0.0001)
    }
    
    // Helper to manage test image files
    private func getSaveURL(filename: String) throws -> URL {
        let fileManager = FileManager.default
        let testDirectory = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent() // Remove filename
        
        if !fileManager.fileExists(atPath: testDirectory.path) {
            try fileManager.createDirectory(at: testDirectory, withIntermediateDirectories: true)
        }
        
        return testDirectory.appendingPathComponent(filename)
    }
    
    func testFetchMapImageForOneLocation() async throws {
        // Emit another location to make sure the backend has data
        let location = CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: 33.001, longitude: -84.001),
            altitude: 0,
            horizontalAccuracy: 5,
            verticalAccuracy: 5,
            timestamp: Date()
        )
        viewModel.handleLocationUpdate(location)
        try await Task.sleep(nanoseconds: 500_000_000)
        
        // Fetch image data directly from API and validate it
        let imageData = try await apiService.fetchMapImage(userId: testUserId)
        let image = try XCTUnwrap(UIImage(data: imageData))
        XCTAssertGreaterThan(image.size.width, 0)
        XCTAssertGreaterThan(image.size.height, 0)
        
        // Save to test directory
        let testImageURL = try getSaveURL(filename: "test_fetch_single.png")
        try imageData.write(to: testImageURL)
        print("Saved generated image to: \(testImageURL.path)")
    }
    
    func testMultipleLocationsAggregateCorrectly() async throws {
        let now = Date()
        let locs = [
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: 33.0, longitude: -84.0),
                       altitude: 0, horizontalAccuracy: 5, verticalAccuracy: 5,
                       timestamp: now),
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: 33.01, longitude: -84.01),
                       altitude: 0, horizontalAccuracy: 5, verticalAccuracy: 5,
                       timestamp: now.addingTimeInterval(1)),
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: 33.02, longitude: -84.02),
                       altitude: 0, horizontalAccuracy: 5, verticalAccuracy: 5,
                       timestamp: now.addingTimeInterval(2))
        ]
        
        for loc in locs {
            viewModel.handleLocationUpdate(loc)
            try await Task.sleep(nanoseconds: 2_000_000_000)
        }
        
        let url = URL(string: "http://127.0.0.1:8000/locations/\(testUserId)")!
        let (data, _) = try await URLSession.shared.data(from: url)

        struct Response: Decodable {
            let id: String
            let locations: [LocationPoint]
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let response = try decoder.decode(Response.self, from: data)
        XCTAssertEqual(response.locations.count, locs.count)
        
        let lastLocation = try XCTUnwrap(response.locations.last)
        XCTAssertEqual(lastLocation.lat, 33.02, accuracy: 0.0001)
        XCTAssertEqual(lastLocation.lon, -84.02, accuracy: 0.0001)
    }
    
    func testFetchMapImageForMultipleLocations() async throws {
        let now = Date()
        
        let locs = [
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: 33.0, longitude: -84.0),
                       altitude: 0, horizontalAccuracy: 5, verticalAccuracy: 5,
                       timestamp: now),
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: 33.01, longitude: -84.01),
                       altitude: 0, horizontalAccuracy: 5, verticalAccuracy: 5,
                       timestamp: now.addingTimeInterval(1)),
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: 33.02, longitude: -84.02),
                       altitude: 0, horizontalAccuracy: 5, verticalAccuracy: 5,
                       timestamp: now.addingTimeInterval(2))
        ]
        
        for loc in locs {
            viewModel.handleLocationUpdate(loc)
            try await Task.sleep(nanoseconds: 500_000_000)
        }
        
        let imageData = try await apiService.fetchMapImage(userId: testUserId)
        let image = try XCTUnwrap(UIImage(data: imageData))
        XCTAssertGreaterThan(image.size.width, 0)
        XCTAssertGreaterThan(image.size.height, 0)
        
        let testImageURL = try getSaveURL(filename: "test_fetch_multiple.png")
        try imageData.write(to: testImageURL)
        print("Saved generated image to: \(testImageURL.path)")
    }
}
*/
