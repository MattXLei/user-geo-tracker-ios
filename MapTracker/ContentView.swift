import SwiftUI
import _LocationEssentials

struct ContentView: View {

    @StateObject private var viewModel: TrackingViewModel

    init(
        userId: String,
        locationService: LocationService,
        coreLocationService: CoreLocationService
    ) {
        _viewModel = StateObject(
            wrappedValue: TrackingViewModel(
                userId: userId,
                locationService: locationService,
                coreLocationService: coreLocationService
            )
        )
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Map Tracker")
                .font(.largeTitle)
                .fontWeight(.bold)

            MapView(viewModel: viewModel)

            Button {
                viewModel.toggleTracking()
            } label: {
                Text(viewModel.isTracking ? "Stop Tracking" : "Start Tracking")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isTracking ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            if let location = viewModel.lastLocation {
                VStack {
                    Text("Latitude: \(location.coordinate.latitude)")
                    Text("Longitude: \(location.coordinate.longitude)")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
    }
}
