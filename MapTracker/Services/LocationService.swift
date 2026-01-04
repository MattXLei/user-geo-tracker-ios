import Foundation

protocol LocationService {
    func sendLocation(_ point: LocationPoint, userId: String) async throws
    func fetchMapImage(userId: String) async throws -> Data
}

/*


import Foundation
import CoreLocation
import SwiftUI

// Handle API requests to the server
class LocationService {
    private let session: URLSession
    private let baseURL: URL
    private let userID: String

    init(
        userID: String,
        baseURL: URL = URL(string: "http://127.0.0.1:8000")!,
        session: URLSession = .shared
    ) {
        self.userID = userID
        self.baseURL = baseURL
        self.session = session
    }

    func sendLocation(_ point: LocationPoint) {
        guard let url = URL(string: "/locations", relativeTo: baseURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "user_id": userID,
            "lat": point.latitude,
            "lon": point.longitude,
            "timestamp": ISO8601DateFormatter().string(from: point.timestamp)
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Location upload error:", error)
            } else {
                print("Location sent successfully")
            }
        }.resume()
    }

    func fetchMap(width: Int = 400, height: Int = 600, zoom: Int = 13, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: "/map/\(userID)?width=\(width)&height=\(height)&zoom=\(zoom)", relativeTo: baseURL) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to fetch map:", error ?? "")
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}*/
