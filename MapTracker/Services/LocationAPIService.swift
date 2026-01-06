import Foundation

final class LocationAPIService: LocationService {

    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL = URL(string: "http://10.0.0.135:8000")!, session: URLSession = .shared) { // "http://127.0.0.1:8000"
        self.baseURL = baseURL
        self.session = session
    }

    func sendLocation(
        _ point: LocationPoint,
        userId: String
    ) async throws {

        let url = baseURL.appendingPathComponent(
            "users/\(userId)/locations"
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try JSONEncoder().encode(point)

        _ = try await session.data(for: request)
    }

    func fetchMapImage(userId: String) async throws -> Data {
        let url = baseURL.appendingPathComponent(
            "users/\(userId)/map"
        )

        let (data, _) = try await session.data(from: url)
        return data
    }
}
