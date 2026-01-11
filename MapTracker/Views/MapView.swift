import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel: TrackingViewModel
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var visibleRegion: MKCoordinateRegion?

    var body: some View {
        ZStack {
            MapReader { reader in
                Map(position: $position) {
                    // User's current location - blue dot
                    if let location = viewModel.lastLocation {
                        Annotation("", coordinate: location.coordinate) {
                            Image(systemName: "location.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 20))
                        }
                    }

                    // Location history as polyline
                    if viewModel.locationHistory.count > 1 {
                        MapPolyline(coordinates: viewModel.locationHistory.map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon) })
                            .stroke(.blue, lineWidth: 2)
                    }

                    // Annotations for each location point
                    ForEach(viewModel.locationHistory, id: \.id) { point in
                        Annotation("", coordinate: CLLocationCoordinate2D(latitude: point.lat, longitude: point.lon)) {
                            Image(systemName: viewModel.selectedLocation?.id == point.id ? "location.circle.fill" : "location.circle")
                                .foregroundColor(viewModel.selectedLocation?.id == point.id ? .red : .orange)
                                .font(.system(size: 16))
                                .onTapGesture {
                                    viewModel.selectLocation(point)
                                }
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .frame(height: 500)
                .onMapCameraChange { context in
                    visibleRegion = context.region
                }
            }

            // Selected location info card
            VStack {
                Spacer()
                
                if let selectedPoint = viewModel.selectedLocation {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Location Details")
                                    .font(.headline)
                                Text("Lat: \(String(format: "%.6f", selectedPoint.lat))")
                                    .font(.caption)
                                Text("Lon: \(String(format: "%.6f", selectedPoint.lon))")
                                    .font(.caption)
                                Text(selectedPoint.timestamp.formatted(date: .abbreviated, time: .standard))
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button(action: { viewModel.deselectLocation() }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding()
                } else {
                    HStack {
                        Image(systemName: "map.fill")
                            .foregroundColor(.blue)
                        Text("Tap a location pin for details")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(8)
                    .padding()
                }
            }
        }
        .padding()
    }
}
