import Foundation
@testable import MapTracker

final class FakeLocationService: LocationService {
    private(set) var sentPoints: [LocationPoint] = []
    var mapImageData: Data?
    var onSend: (() -> Void)?

    func sendLocation(_ point: LocationPoint, userId: String) async throws {
        sentPoints.append(point)
        onSend?()
    }

    func fetchMapImage(userId: String) async throws -> Data {
        return mapImageData ?? Data()
    }
}

