import Foundation

struct LocationPoint: Codable, Identifiable, Equatable {
    let id: String
    let latitude: Double
    let longitude: Double
    let timestamp: Date
}
