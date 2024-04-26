import SwiftUI
import MapKit

struct MapView: NSViewRepresentable {
    @State private var directions: MKRoute?

    let sourceLocation: CLLocationCoordinate2D
    let destinationLocation: CLLocationCoordinate2D

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
            renderer.strokeColor = .blue
            renderer.lineWidth = 3
            return renderer
        }
    }
}

struct MapContentView: View {
    var body: some View {
        MapView(sourceLocation: CLLocationCoordinate2D(latitude: 40.564487127002295, longitude: -74.34545746055808),
                destinationLocation: CLLocationCoordinate2D(latitude: 40.558323795090125, longitude: -74.33727343357657))
            .frame(width: 400, height: 400)
    }
}
