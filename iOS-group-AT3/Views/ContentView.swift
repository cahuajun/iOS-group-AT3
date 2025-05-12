//
//  ContentView.swift
//  iOS-group-AT3
//
//  Created by Elena O'Keeffe on 7/5/2025.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var isActive = false
    @State private var selectedLocation = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
    @State private var startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    
    @State private var selection: ParkingSpot? = nil
    @State private var allSpots = [
        ParkingSpot(name: "Spot 1", description: "TestDesc1", imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTF3xs3i2bH-q15i4WK6H8qd3F9MJfxoR6kgw&s", rating: 10.0, lat: 51.507222, long: -0.1275, comments: []),
        ParkingSpot(name: "Spot 2", description: "TestDesc2", imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTF3xs3i2bH-q15i4WK6H8qd3F9MJfxoR6kgw&s", rating: 10.0, lat: 51.537222, long: -0.1275, comments: []),
        ParkingSpot(name: "Spot 3", description: "TestDesc3", imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTF3xs3i2bH-q15i4WK6H8qd3F9MJfxoR6kgw&s", rating: 10.0, lat: 51.537222, long: -0.1475, comments: [])
        ]
    
    var body: some View {
        ZStack{
            
//            Map(position: $startPosition, selection: $selection){
//                ForEach(allSpots){ spot in
//                    Marker(item: MKMapItem() ).mapItemDetailSelectionAccessory(.callout).tag(MapSelection(spot))
//                }.mapItemDetailSelectionAccessory(.callout)
//            }.frame(width: 400, height: 300)
            Map(selection: $selection) {
                ForEach(allSpots) { spot in
                    Marker(spot.name, coordinate: CLLocationCoordinate2D(latitude: spot.lat, longitude: spot.long))
                        .tag(spot)
                }
            }
            .sheet(item: $selection) { spot in
                NavigationStack {
                    DetailView(parkingSpot: spot)
                }
                .presentationDetents([.medium])
            }
            
        }
    }
}


#Preview {
    ContentView()
}
