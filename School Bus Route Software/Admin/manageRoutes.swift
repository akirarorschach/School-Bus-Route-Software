//
//  manageRoutes.swift
//  School Bus Route Software
//
//  Created by Alvin Wu on 2024-04-03.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var annotations: [MKPointAnnotation] = []
    @State private var route: MKRoute?

    let sourceLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco
    let destinationLocation = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437) // Los Angeles

    var body: some View {
        MapView(annotations: annotations, route: route)
            .onAppear {
                // Create annotations
                let sourceAnnotation = MKPointAnnotation()
                sourceAnnotation.coordinate = sourceLocation
                sourceAnnotation.title = "San Francisco"
                annotations.append(sourceAnnotation)

                let destinationAnnotation = MKPointAnnotation()
                destinationAnnotation.coordinate = destinationLocation
                destinationAnnotation.title = "Los Angeles"
                annotations.append(destinationAnnotation)

                // Calculate route
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceLocation))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationLocation))
                let directions = MKDirections(request: request)
                directions.calculate { response, error in
                    guard let route = response?.routes.first else { return }
                    self.route = route
                }
            }
    }
}

struct ContentView_Provider: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MapView: View {
    var annotations: [MKPointAnnotation]
    var route: MKRoute?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = Context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)

        if let route = route {
            uiView.addOverlay(route.polyline)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}
