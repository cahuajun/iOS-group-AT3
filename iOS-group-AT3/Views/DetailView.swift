//
//  DetailView.swift
//  iOS-group-AT3
//
//  Created by 王嘉瑶 on 9/5/2025.
//

import SwiftUI
import MapKit

/// A view that displays detailed information about a parking spot.
///
/// This view shows the parking spot's image, name, description, and comments.
/// It also provides functionality to mark a spot as parked and view more comments.
struct DetailView: View {
    let parkingSpot: ParkingSpot
    
    @State private var isExpanded = false
    @State private var dragOffset: CGFloat = 0
    @State private var showComments = false
    @State private var isParked = false
    @State private var previewComments: [Comment] = []
    
    /// Loads comments for the current parking spot from comments.json.
    ///
    /// Can read comments from comments.json file, also filter comments for the current parking spot.
    private func loadComments() {
        previewComments = Utility.loadComments(for: parkingSpot.id)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top drag bar for expanding/collapsing the view
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isExpanded.toggle()
                        }
                    }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Parking spot image
                        Image(parkingSpot.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                        
                        // Name and rating section
                        HStack {
                            Text(parkingSpot.name)
                                .font(.title)
                                .bold()
                            Spacer()
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", Utility.calculateAverageRating(for: previewComments)))
                            }
                        }
                        .padding(.horizontal)
                        
                        // Park Here button
                        Button(action: {
                            isParked.toggle()
                            if isParked {
                                Utility.addCount(for: parkingSpot.id)
//                                let updatedSpots = Utility.loadParkingSpots()
//                                if let spot = updatedSpots.first(where: {$0.id == ParkingSpot.id}) {
//                                    print ("updated ocunt : \(spot.count)")
//                                }
                            }
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
                            
                            if !previewComments.isEmpty {
                                ForEach(previewComments) { comment in
                                    CommentRow(comment: comment)
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
        .onAppear {
            loadComments()
        }
    }
}

/// A view that displays a single comment in the detail view.
///
/// This view shows the comment's author, rating, text content, and timestamp.
struct CommentRow: View {
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(comment.author)
                    .font(.headline)
                Spacer()
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", Double(comment.rating)))
                }
            }
            
            Text(comment.text)
                .foregroundColor(.gray)
            
            Text(comment.timestamp, style: .date)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

#Preview {
    DetailView(parkingSpot: ParkingSpot(
        id: "T1",
        name: "Thomas Street 1",
        description: "Two-storey parking lo",
        imageName: "image1",
        rating: 4.5,
        lat: -33.8833,
        long: 151.1996,
        count: 0,
        date: Date(),
        comments: []
    ))
}
