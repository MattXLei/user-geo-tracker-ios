# user-geo-tracker-ios

A real-time location tracking and interactive map visualization app for iOS. Captures user location via CoreLocation and displays movement history on an interactive MapKit map with gesture support for pan, zoom, and point selection.

## Features

* **Real-Time Location Tracking**: Capture user location with automatic filtering based on distance and time thresholds.
* **Interactive Map Visualization**: Display user location and history on Apple MapKit with native pan/zoom gestures.
* **Location History**: View your complete movement path as a polyline on the map.
* **User Location Indicator**: See your current position with the standard blue dot indicator.

## Requirements

* iOS 17.0 or higher
* Xcode 15.0 or higher
* Swift 5.9 or higher

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/MattXLei/user-geo-tracker-ios.git
   cd user-geo-tracker-ios/MapTracker
   ```

2. Open the project in Xcode:
   ```bash
   open MapTracker.xcodeproj
   ```

3. Select your target device/simulator and build:
   ```bash
   cmd + B
   ```

## Usage

### Running the App

1. Open `MapTracker.xcodeproj` in Xcode
2. Select your target device or simulator
3. Press `cmd + R` to build and run

### How It Works

1. **Start Tracking**: Tap the tracking toggle button to begin capturing your location
2. **View Map**: Your location and path history appear automatically on the interactive map
3. **Interact with Map**: Use standard gestures to pan, zoom, and rotate the map
4. **Stop Tracking**: Tap the toggle again to stop location capture

### Location Filtering

The app intelligently filters location points to avoid noise:
* **Minimum Distance**: 5 meters between consecutive points
* **Minimum Time**: 5 seconds between consecutive points

## Project Structure

```
MapTracker/
├── Views/
│   ├── ContentView.swift          # Main app UI
│   └── MapView.swift              # Interactive MapKit visualization
├── ViewModels/
│   └── TrackingViewModel.swift    # Location tracking state management
├── Models/
│   └── LocationPoint.swift        # Location data structure
├── Services/
│   ├── CoreLocationService.swift  # CoreLocation wrapper
└── MapTrackerApp.swift            # App entry point
```

## Testing

Run the test suite:
```bash
cmd + U
```

Tests cover:
* Location history filtering and validation
* Location point selection/deselection
* Tracking state management

## Legacy: Python Backend Integration

This project originally used a Python backend server to generate static PNG map images. The backend code has been preserved as comments in the `fastapi` branch for reference.

## Future Enhancements

* Route calculation and turn-by-turn directions
* Geofencing alerts
* Location clustering for dense point visualization
* Export location history (GPX, CSV)
* Background location tracking