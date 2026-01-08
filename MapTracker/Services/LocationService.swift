import Foundation

protocol LocationService {
    func sendLocation(_ point: LocationPoint, userId: String) async throws
    //func fetchMapImage(userId: String) async throws -> Data
}
