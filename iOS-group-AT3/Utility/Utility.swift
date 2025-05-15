//
//  Utility.swift
//  iOS-group-AT3
//
//  Created by JW on 14/5/2025.
//

import Foundation

class Utility {
    static func loadParkingSpots() -> [ParkingSpot] {
        guard let url = Bundle.main.url(forResource: "parking_history", withExtension: "json") else {
            print("❌ parking_history.json not found in Data folder")
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
    
    static func loadComments(for spotID: String) -> [Comment] {
        guard let url = Bundle.main.url(forResource: "comments", withExtension: "json") else {
            print("❌ comments.json not found in Data folder")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let commentsDict = try decoder.decode([String: [Comment]].self, from: data)
            return commentsDict[spotID] ?? []
        } catch {
            print("❌ Failed to decode comments.json: \(error)")
            return []
        }
    }
    
    static func calculateAverageRating(for comments: [Comment]) -> Double {
        guard !comments.isEmpty else { return 0 }
        let totalRating = comments.reduce(0) { $0 + $1.rating }
        return Double(totalRating) / Double(comments.count)
    }
}
