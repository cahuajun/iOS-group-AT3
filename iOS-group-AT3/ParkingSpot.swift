//
//  ParkingSpot.swift
//  iOS-group-AT3
//
//  Created by 王嘉瑶 on 12/5/2025.
//

import Foundation
 
struct ParkingSpot: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageURL: String
    let rating: Double
    let comments: [Comment]
}
 
struct Comment: Identifiable {
    let id = UUID()
    let username: String
    let content: String
    let rating: Int
    let date: Date
}
