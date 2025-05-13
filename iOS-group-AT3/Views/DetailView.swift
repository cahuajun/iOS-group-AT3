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
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        AsyncImage(url: URL(string: parkingSpot.imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                        }
                        .frame(height: 200)
                        .clipped()
                        
                        HStack {
                            Text(parkingSpot.name)
                                .font(.title)
                                .bold()
                            Spacer()
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", parkingSpot.rating))
                            }
                        }
                        .padding(.horizontal)
                        
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
                CommentSectionView(parkingSpotID: parkingSpot.id.uuidString)
            }
        }
    }
}
 
 
#Preview {
    DetailView(parkingSpot: ParkingSpot(
        name: "Thomas Street 1",
        description: "Description",
        imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTF3xs3i2bH-q15i4WK6H8qd3F9MJfxoR6kgw&s",
        rating: 4.5,
        lat: -33.882889,
        long: 151.199611,
        comments: []
    ))
}
