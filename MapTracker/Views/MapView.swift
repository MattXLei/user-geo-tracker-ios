import SwiftUI

struct MapView: View {
    @ObservedObject var viewModel: TrackingViewModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))

            if let image = viewModel.mapImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "map")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)

                    Text("Map Preview")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
        }
        .frame(height: 500)
        .padding()
    }
}
