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
    @State private var startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -33.882889, longitude: 151.199611), span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)))
    
    @State private var selection: ParkingSpot? = nil
    @State var allSpots: [ParkingSpot]
    var showHistory: Bool = true
    
    var body: some View {
        VStack{
            NavigationStack{
                NavigationLink {
                    ParkingHistoryView()
                } label: {
                    HStack{
                        Text("My Parking History")
                        Image(systemName: "clock")
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                ZStack{
                    Map(initialPosition:  startPosition, interactionModes: .all, selection: $selection) {
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
                    }.onAppear {
                        loadJSONData()
                    }
                }
                
            }
        }
    }
    func loadJSONData() {
        allSpots = Utility.loadParkingSpots()
    }
}

#Preview {
    ContentView(allSpots:[]
    
    )
}
