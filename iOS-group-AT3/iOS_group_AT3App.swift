//
//  iOS_group_AT3App.swift
//  iOS-group-AT3
//
//  Created by Elena O'Keeffe on 7/5/2025.
//

import SwiftUI

@main
struct iOS_group_AT3App: App {
    

    var body: some Scene {
            var allSport: [ParkingSpot] = loadJSONData()
            WindowGroup {
                ContentView(allSpots: allSport)
            }
    }
    
    func loadJSONData() -> [ParkingSpot]{
        guard let url = Bundle.main.url(forResource: "parking_history", withExtension: "json") else {
            print("❌ parking_history.json not found")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([ParkingSpot].self, from: data)
        } catch {
            print("❌ Failed to decode parking_history.json: \(error)")
            return []
        }
    }
}
