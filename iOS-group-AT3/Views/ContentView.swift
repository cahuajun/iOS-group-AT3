//
//  ContentView.swift
//  iOS-group-AT3
//
//  Created by Elena O'Keeffe on 7/5/2025.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    /**
     Present the user with a map of available parking spots
     Each parking spot is represented by a clickable pin
     */
    @State private var startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -33.882889, longitude: 151.199611), span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)))
    
    /**
     Selection allows the correct details for the selected pin to be loaded in the detail view
     */
    @State private var selection: ParkingSpot? = nil
    
    /**
     A list of available parking spots which is populated from a json resource onAppear of the Map
     */
    @State var allSpots: [ParkingSpot]
    
    var body: some View {
        VStack{
            NavigationStack{
                /**
                 Present a link to the user's parking history
                 For demonstration purposes this is loaded from a .json resource
                 If this application was to be further developed these should come from a database
                 */
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
                    /**
                     A map of recorded parking spots
                     This map initially shows the UTS area parking spots are shown on the map as pins
                     */
                    Map(initialPosition:  startPosition,
                        /**
                         Allow all interaction modes including pan, zoom, pitch and rotate
                         */
                        interactionModes: .all,
                        
                        selection: $selection) {
                        ForEach(allSpots) { spot in
                            Marker(spot.name,
                                   coordinate: CLLocationCoordinate2D(latitude: spot.lat, longitude: spot.long))
                                .tag(spot)
                        }
                    }
                    .sheet(item: $selection) { spot in
                        /**
                         This sheet slides up from the bottom of the screen to show the details of the selected parking spot
                         */
                        NavigationStack {
                            DetailView(parkingSpot: spot)
                        }
                        /**
                         The details view occupies approximately half of the screen
                         Details view can be dismissed by clicking on the map
                         */
                        .presentationDetents([.medium])
                    }
                    .onAppear {
                        /**
                         Initialise parking spots from .json resource for demo
                         To productionise this we would implement a connection to a database
                         */
                        allSpots = Utility.loadParkingSpots()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView(allSpots:[])
}
