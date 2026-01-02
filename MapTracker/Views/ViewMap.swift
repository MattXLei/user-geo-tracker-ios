import SwiftUI

struct MapView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .cornerRadius(12)

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
        .frame(height: 300)
        .padding()
    }
}

// Placeholder for now
