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
                        
                        // Comment view
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
            // TODO: Add comment sheet
        }
    }
}
 
// TODO: Add commentRow view
// TODO: Add commentsView
 
#Preview {
    DetailView(parkingSpot: ParkingSpot(
        name: "parkingspot1",
        description: "Description",
        imageURL: "https://example.com/parking.jpg",
        rating: 4.5,
        lat: 51.507222,
        long: -0.1275,
        comments: []
    ))
}
