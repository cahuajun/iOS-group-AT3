//
//  DetailView.swift
//  iOS-group-AT3
//
//  Created by 王嘉瑶 on 9/5/2025.
//
 
import SwiftUI
import MapKit
 
struct DetailView: View {
    let parkingSpot: ParkingSpot
    
    @State private var isExpanded = false
    @State private var dragOffset: CGFloat = 0
    @State private var showComments = false
    @State private var isParked = false
    
    // Calculate average rating from comments， maybe can add func to parkingSPot file to avoid DRY
    private var averageRating: Double {
        let total = parkingSpot.comments.reduce(0) { $0 + $1.rating }
        return parkingSpot.comments.isEmpty ? 0.0 : Double(total) / Double(parkingSpot.comments.count)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top drag bar
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Parking spot image
                        Image(parkingSpot.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                        
                        // Name and rating
                        HStack {
                            Text(parkingSpot.name)
                                .font(.title)
                                .bold()
                            Spacer()
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", averageRating))
                            }
                        }
                        .padding(.horizontal)
                        
                        // Park Here button
                        Button(action: {
                            isParked.toggle()
                            // TODO: Update count in parking_history.json
                            // 1. Read current JSON
                            // 2. Find spot by id
                            // 3. Increment count
                            // 4. Save back to JSON
                        }) {
                            HStack {
                                Image(systemName: isParked ? "checkmark.circle.fill" : "car.fill")
                                Text(isParked ? "Parked" : "Park Here")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isParked ? Color.green : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        // Description
                        Text(parkingSpot.description)
                            .padding(.horizontal)
                        
                        // Comments section
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Comments")
                                    .font(.headline)
                                Spacer()
                                Button(action: {
                                    showComments = true
                                }) {
                                    Text("View More")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal)
                            
                            if !parkingSpot.comments.isEmpty {
                                ForEach(parkingSpot.comments.prefix(2)) { comment in
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(comment.author)
                                                .font(.subheadline)
                                                .bold()
                                            Spacer()
                                            HStack(spacing: 2) {
                                                ForEach(1...5, id: \.self) { i in
                                                    Image(systemName: i <= comment.rating ? "star.fill" : "star")
                                                        .foregroundColor(.yellow)
                                                        .font(.caption)
                                                }
                                            }
                                        }
                                        Text(comment.text)
                                            .font(.subheadline)
                                            .lineLimit(2)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                }
                            } else {
                                Text("No comments yet")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 5)
            .offset(y: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.height
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if value.translation.height > 100 {
                                isExpanded = false
                                dragOffset = 0
                            } else {
                                isExpanded = true
                                dragOffset = 0
                            }
                        }
                    }
            )
            .sheet(isPresented: $showComments) {
                CommentSectionView(parkingSpotID: parkingSpot.id)
            }
        }
    }
}

/*
 Notes for ContentView:

    - Data Loading
        - Load parking_history.json
        - Parse to [ParkingSpot] array
        - Get comments from comments.json
        - Merge comments with spots

    - Map View
        - Show pins for each spot
        - When pin tapped, show this DetailView
        - Use sheet with .medium detent

    - Files Needed
        - parking_history.json (spot info)
        - comments.json (comments)

    - ParkingSpot Struct
        - id, name, description
        - imageName for spot image
        - lat, long for map
        - comments array

    - Next Steps
        - Load JSON in ContentView
        - Connect map pins to DetailView
        - Test data flow
 */
#Preview {
    DetailView(parkingSpot: ParkingSpot(
        id: "T1",
        name: "Thomas Street 1",
        description: "No description available.",
        imageName: "image1",
        rating: 4.5,
        lat: -33.882889,
        long: 151.199611,
        count: 0,
        date: Date(),
        comments: []
    ))
}
