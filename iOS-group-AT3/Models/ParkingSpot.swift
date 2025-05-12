//
//  ParkingSpot.swift
//  iOS-group-AT3
//
//  Created by 王嘉瑶 on 12/5/2025.
//

import Foundation
import MapKit
 
struct ParkingSpot: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let imageURL: String
    let rating: Double
    let lat: Double
    let long: Double
    let comments: [Comment]
    
}

