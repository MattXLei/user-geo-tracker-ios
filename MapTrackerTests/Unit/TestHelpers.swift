import CoreLocation

func makeLocation(lat: Double, lon: Double, timestamp: Date) -> CLLocation {
    CLLocation(
        coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
        altitude: 0,
        horizontalAccuracy: 5,
        verticalAccuracy: 5,
        timestamp: timestamp
    )
}
