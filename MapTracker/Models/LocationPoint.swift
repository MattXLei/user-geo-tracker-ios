import Foundation

struct LocationPoint: Codable, Identifiable, Equatable {
    let id: String
    let lat: Double
    let lon: Double
    let timestamp: Date
}
