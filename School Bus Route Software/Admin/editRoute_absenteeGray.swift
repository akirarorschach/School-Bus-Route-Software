import SwiftUI
import MapKit

struct MapView: NSViewRepresentable {
    @Binding var directions: MKRoute?
    var sourceLocation: CLLocationCoordinate2D
    var destinationLocation: CLLocationCoordinate2D

    func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator // Set Coordinator as delegate
        return mapView
    }

    func updateNSView(_ mapView: MKMapView, context: Context) {
        // Remove any existing overlays
        mapView.removeOverlays(mapView.overlays)

        // Create and add the overlay for the route if directions are available
        if let route = directions?.polyline {
            mapView.addOverlay(route)
            mapView.setVisibleMapRect(route.boundingMapRect, animated: true)
        } else {
            // Calculate directions if not already calculated
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceLocation))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationLocation))
            request.transportType = .automobile

            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                DispatchQueue.main.async {
                    guard let route = response?.routes.first, error == nil else {
                        // Handle error
                        return
                    }
                    self.directions = route
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer()
            }
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = NSColor(red: 0.44, green: 1.0, blue: 0.44, alpha: 1.0) // Bright neon green
            renderer.lineWidth = 3
            return renderer
        }
    }
}

struct MapContentView: View {
    @State private var selectedSource: String = "Edison High School"
    @State private var selectedDestinationIndex = 0
    @State private var directions: MKRoute?
    @State private var showMap: Bool = false

    let destinations: [String: CLLocationCoordinate2D] = [
        "192 Evergreen Rd, Edison, NJ 08837": CLLocationCoordinate2D(latitude: 40.558323795090125, longitude: -74.33727343357657),
        "128 N Evergreen Rd, Edison, NJ 08837": CLLocationCoordinate2D(latitude: 40.55827490108172, longitude: -74.33716520304641),
        "99 Calvert Ave E, Edison, NJ 08820": CLLocationCoordinate2D(latitude: 40.5645034278468, longitude: -74.34537162986709)
    ]

    var availableDestinations: [String] {
        destinations.keys.sorted()
    }

    var isGenerateRouteDisabled: Bool {
        availableDestinations[selectedDestinationIndex] == "128 N Evergreen Rd, Edison, NJ 08837"
    }

    var body: some View {
        VStack {
            Picker("Source Location", selection: $selectedSource) {
                Text("Edison High School").tag("Edison High School")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Picker("Destination Location", selection: $selectedDestinationIndex) {
                ForEach(0..<availableDestinations.count, id: \.self) { index in
                    if availableDestinations[index] == "128 N Evergreen Rd, Edison, NJ 08837" {
                        Text(availableDestinations[index])
                            .foregroundColor(.gray)
                            .tag(nil as Int?)
                            .disabled(true)
                    } else {
                        Text(availableDestinations[index])
                            .tag(index)
                    }
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Button("Generate Route") {
                if let destination = destinations[availableDestinations[selectedDestinationIndex]] {
                    showMap = true
                    directions = nil // Reset directions to trigger recalculation
                }
            }
            .padding()
            .disabled(isGenerateRouteDisabled)

            if showMap {
                MapView(directions: $directions,
                        sourceLocation: CLLocationCoordinate2D(latitude: 40.51430828261209, longitude: -74.386332670696),
                        destinationLocation: destinations[availableDestinations[selectedDestinationIndex]]!)
                    .frame(width: 400, height: 400)
                    .popover(isPresented: $showMap, attachmentAnchor: .rect(.bounds)) {
                        VStack {
                            Text("Directions")
                            Divider()
                            if let directions = directions {
                                Text("Total Travel Time: \(formattedTime(duration: directions.expectedTravelTime))")
                                ForEach(directions.steps, id: \.instructions) { step in
                                    VStack(alignment: .leading) {
                                        Text(step.instructions)
                                            .padding(.vertical, 5)
                                        Text("Distance: \(String(format: "%.2f", step.distance * 0.000621371)) miles")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(width: 300) // Adjust the width of the popover
                    }
            }

            Spacer() // Add spacer to push the button to the top
        }
    }

    func formattedTime(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: duration) ?? ""
    }
}

struct MapContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapContentView()
    }
}
