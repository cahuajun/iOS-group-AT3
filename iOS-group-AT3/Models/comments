//
//  comments.swift
//  iOS-group-AT3
//
//  Created by Chao Wan on 13/5/2025.
//
import Foundation
import UIKit

struct Reply: Identifiable, Hashable, Codable {
    let id: UUID = UUID()
    let author: String
    let text: String
    let timestamp: Date
}

struct Comment: Identifiable, Hashable, Codable {
    let id: UUID = UUID()
    let author: String
    let text: String
    let rating: Int
    let timestamp: Date
    var likes: Int = 0
    var replies: [Reply] = []

 
    var image: UIImage? = nil
    var isCurrentUser: Bool = false

    enum CodingKeys: String, CodingKey {
        case author, text, rating, timestamp, likes, replies
    }
}

