//
//  ParkingHistoryView.swift
//  iOS-group-AT3
//
//  Created by Chunyan Wang on 9/5/2025.
//

import SwiftUI

struct ParkingHistoryView: View {
    @State private var records: [ParkingSpot] = []
    @State private var sortByMostVisited = false

    var sortedRecords: [ParkingSpot] {
        sortByMostVisited
            ? records.sorted { $0.count > $1.count }
            : records.sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("Sort By", selection: $sortByMostVisited) {
                    Text("Latest").tag(false)
                    Text("Most Visited").tag(true)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List(sortedRecords) { record in
                    HStack(spacing: 16) {
                        Image(record.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                            .clipped()

                        VStack(alignment: .leading) {
                            Text(record.name)
                                .font(.headline)
                            Text("Visited \(record.count)x")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(record.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Parking History")
            .onAppear {
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
            self.records = try decoder.decode([ParkingSpot].self, from: data)
        } catch {
            print("❌ Failed to decode parking_history.json: \(error)")
        }
    }
}

#Preview {
    ParkingHistoryView()
}

