//
//  ParkingHistoryView.swift
//  iOS-group-AT3
//
//  Created by Chunyan Wang on 9/5/2025.
//

import SwiftUI


struct ParkingRecord: Identifiable {
    let id = UUID()
    let locationName: String
    let date: Date
    let imageName: String // need to put on Assets.xcassets
}


struct ParkingHistoryView: View {
    // example
    @State private var records: [ParkingRecord] = [
        ParkingRecord(locationName: "Broadway UTS Parking", date: Date(), imageName: "uts1"),
        ParkingRecord(locationName: "Jones St Parking", date: Date().addingTimeInterval(-86400), imageName: "uts2"),
        ParkingRecord(locationName: "Ultimo TAFE Parking", date: Date().addingTimeInterval(-172800), imageName: "uts3")
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(records) { record in
                    HStack(spacing: 16) {
                        Image(record.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipped()
                            .cornerRadius(10)

                        VStack(alignment: .leading) {
                            Text(record.locationName)
                                .font(.headline)
                            Text(record.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Parking History")
        }
    }
}

