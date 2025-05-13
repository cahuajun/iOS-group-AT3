//
//  ParkingSpot.swift
//  iOS-group-AT3
//
//  Created by 王嘉瑶 on 12/5/2025.
//

import Foundation
import MapKit

struct ParkingSpot: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let imageName: String
    let rating: Double
    let lat: Double
    let long: Double
    let count: Int
    let date: Date
}

