import Foundation
@testable import MapTracker

final class FakeLocationService: LocationService {
    private(set) var sentPoints: [LocationPoint] = []
    var mapImageData: Data?
    var onSend: (() -> Void)?
    var onMapUpdated: (() -> Void)?

    func sendLocation(_ point: LocationPoint, userId: String) async throws {
        sentPoints.append(point)
        onSend?()
    }
}
