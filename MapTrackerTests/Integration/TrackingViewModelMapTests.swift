import XCTest
import UIKit
@testable import MapTracker

@MainActor
final class TrackingViewModelMapIntegrationTests: XCTestCase {

    func testMapImageIsUpdatedAfterLocationSent() async {
        let fakeLocationService = FakeLocationService()
        let fakeCoreLocationService = FakeCoreLocationService()

        // Prepare fake PNG data
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 10, height: 10))
        let image = renderer.image { ctx in
            UIColor.red.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 10, height: 10))
        }

        fakeLocationService.mapImageData = image.pngData()

        let viewModel = TrackingViewModel(
            userId: "test-user",
            locationService: fakeLocationService,
            coreLocationService: fakeCoreLocationService
        )

        fakeCoreLocationService.emit(
            latitude: 33.0,
            longitude: -84.0
        )

        // Give async task time to complete
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(viewModel.mapImage)
    }
}

