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
    @State private var startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -33.882889, longitude: 151.199611), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    
    @State private var selection: ParkingSpot? = nil
    @State var allSpots: [ParkingSpot]
    var body: some View {
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
    func loadJSONData() {
        guard let url = Bundle.main.url(forResource: "parking_history", withExtension: "json") else {
            print("❌ parking_history.json not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            self.allSpots = try decoder.decode([ParkingSpot].self, from: data)
        } catch {
            print("❌ Failed to decode parking_history.json: \(error)")
        }
    }
}


#Preview {
    ContentView(allSpots:
                [ParkingSpot( id: "T1",
                                 name: "Thomas Street 1",
                                 description: "Two-storey parking lot",
                                 imageName: "image1",
                                 rating: 4.5,
                                 lat: -33.882889,
                                 long: 151.199611,
                                 count: 5,
                                 date: Date(),
                                 comments:[]),
                 ParkingSpot(
                   id: "M1",
                   name: "Mary Ann Street 1",
                   description: "Near the UTS campus",
                   imageName: "image2",
                   rating: 4.0,
                   lat: -33.881278,
                   long: 151.199083,
                   count: 2,
                   date: Date(),
                   comments:[]
                 ),
                 ParkingSpot(
                   id: "B1",
                   name: "Blackfriars Pi 1",
                   description: "Solely for students",
                   imageName: "image3",
                   rating: 3.5,
                   lat: -33.885639,
                   long: 151.198083,
                   count: 1,
                   date: Date(),
                   comments: []
                 ),
                 ParkingSpot(
                   id: "W1",
                   name: "Wattle Street 1",
                   description: "Only two, sometimes depends on the lucky",
                   imageName: "image2",
                   rating: 4.2,
                   lat: -33.882083,
                   long: 151.197528,
                   count: 2,
                   date: Date(),
                   comments:[]
                 ),
                
                ]
    
    )
}
