import CoreLocation

protocol CoreLocationService {
    var isRunning: Bool { get }
    func start(updating handler: @escaping (CLLocation) -> Void)
    func stop()
}
