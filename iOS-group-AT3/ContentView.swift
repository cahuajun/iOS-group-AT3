//
//  ContentView.swift
//  iOS-group-AT3
//
//  Created by Elena O'Keeffe on 7/5/2025.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    Map{
        Marker("Parking 1", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275))
        Marker("Parking 2", coordinate: CLLocationCoordinate2D(latitude: 51.537222, longitude: -0.1275))
        Marker("Parking 3", coordinate: CLLocationCoordinate2D(latitude: 51.537222, longitude: -0.1475))
    }.frame(width: 400, height: 300)
    }
}

#Preview {
    ContentView()
}
