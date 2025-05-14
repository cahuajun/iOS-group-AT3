//
//  Utility.swift
//  iOS-group-AT3
//
//  Created by 王嘉瑶 on 14/5/2025.
//

import Foundation

class Utility {
//    static func loadParkingSpots() -> [ParkingSpot] {
//        guard let url = Bundle.main.url(forResource: "parking_history", withExtension: "json") else {
//            print("❌ parking_history.json not found in Data folder")
//            return []
//        }
//        
//        do {
//            let data = try Data(contentsOf: url)
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
//            return try decoder.decode([ParkingSpot].self, from: data)
//        } catch {
//            print("❌ Failed to decode parking_history.json: \(error)")
//            return []
//        }
//    }
    private static func getDocumentsDirectory() -> URL {
           FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
       }
       
       static func loadParkingSpots() -> [ParkingSpot] {
           // 首先尝试从文档目录读取
           let fileURL = getDocumentsDirectory().appendingPathComponent("parking_history.json")
           
           if FileManager.default.fileExists(atPath: fileURL.path) {
               do {
                   let data = try Data(contentsOf: fileURL)
                   let decoder = JSONDecoder()
                   // 使用ISO8601格式解码日期
                   let dateFormatter = ISO8601DateFormatter()
                   decoder.dateDecodingStrategy = .custom { decoder in
                       let container = try decoder.singleValueContainer()
                       let dateString = try container.decode(String.self)
                       if let date = dateFormatter.date(from: dateString) {
                           return date
                       }
                       throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
                   }
                   return try decoder.decode([ParkingSpot].self, from: data)
               } catch {
                   print("❌ Failed to read from documents directory: \(error)")
               }
           }
           
           // 如果文档目录中没有文件，则从Bundle读取
           guard let url = Bundle.main.url(forResource: "parking_history", withExtension: "json") else {
               print("❌ parking_history.json not found")
               return []
           }
           
           do {
               let data = try Data(contentsOf: url)
               let decoder = JSONDecoder()
               // 使用ISO8601格式解码日期
               let dateFormatter = ISO8601DateFormatter()
               decoder.dateDecodingStrategy = .custom { decoder in
                   let container = try decoder.singleValueContainer()
                   let dateString = try container.decode(String.self)
                   if let date = dateFormatter.date(from: dateString) {
                       return date
                   }
                   throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
               }
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
    
//    static func addCount (for spotID: String) {
//        var parkingSpots = loadParkingSpots()
//        if let index = parkingSpots.firstIndex(where: {$0.id == spotID }) {
//            parkingSpots[index].count += 1
//            
//            DispatchQueue.global(qos: .background).async {
//                do{
//                    let encoder = JSONEncoder()
//                    encoder.outputFormatting = .prettyPrinted
//                    _ = ISO8601DateFormatter()
//                    encoder.dateEncodingStrategy = .custom{ date, encoder in
//                        var container = encoder.singleValueContainer()
//                        try container.encode(parkingSpots)
//                    }
//                    
//                    let updatedDate = try encoder.encode(parkingSpots)
//                    let fileURL = getDocumentsDirectory().appendingPathComponent("parking_history.json")
//                    
//                    try updatedDate.write(to: fileURL)
//                    print("success")
//                } catch {
//                    print("Failed to write data into json file")
//                }
//            }
//        }
//    }
}
