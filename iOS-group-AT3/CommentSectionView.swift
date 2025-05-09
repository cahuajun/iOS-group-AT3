//
//  CommentSectionView.swift
//  iOS-group-AT3
//
//  Created by Chao Wan on 9/5/2025.
//
import UIKit
import SwiftUI
import PhotosUI

// MARK: - strucure
struct Comment: Identifiable {
    let id = UUID()
    let author: String
    let text: String
    let rating: Int
    let timestamp: Date
    let image: UIImage? // add photo later
    let isCurrentUser: Bool
    var likes: Int = 0
}

// MARK: - Main comments view
struct CommentSectionView: View {
    let parkingSpotID: String
    
    // current comments
    @State private var comments: [Comment] = [
        Comment(author: "Alice", text: "Nice spot!", rating: 5, timestamp: Date(), image: nil, isCurrentUser: false, likes: 3),
        Comment(author: "Bob", text: "A bit tight for SUVs.", rating: 3, timestamp: Date(), image: nil, isCurrentUser: false, likes: 1)
    ]
    
    // new comment input
    @State private var newComment = ""
    @State private var newRating = 0
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    
    var averageRating: Double {
        let total = comments.reduce(0) { $0 + $1.rating }
        return comments.isEmpty ? 0.0 : Double(total) / Double(comments.count)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // 🔹 Top info
                        VStack(alignment: .leading, spacing: 8) {
                            Text("🏷 Parking Spot: \(parkingSpotID)")
                                .font(.subheadline)
                                .bold()
                            Text("💬 \(comments.count) Comment(s)")
                                .font(.subheadline)
                            Text("⭐️ Average Rating: \(String(format: "%.1f", averageRating))")
                                .font(.subheadline)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        //  Comments list
                        ForEach(comments) { comment in
                            CommentCard(comment: comment, onDelete: {
                                if let index = comments.firstIndex(where: { $0.id == comment.id }) {
                                    comments.remove(at: index)
                                }
                            }, onLike: {
                                if let index = comments.firstIndex(where: { $0.id == comment.id }) {
                                    comments[index].likes += 1
                                }
                            })
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
                
                // comment input area not move
                .safeAreaInset(edge: .bottom) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Rate this spot").font(.subheadline)
                        HStack {
                            ForEach(1...5, id: \.self) { i in
                                Image(systemName: i <= newRating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .onTapGesture { newRating = i }
                            }
                            Text("\(newRating).0").foregroundColor(.gray)
                        }
                        
                        Text("Your Comment").font(.subheadline)
                        TextEditor(text: $newComment)
                            .frame(height: 80)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                        
                        Button {
                            showImagePicker = true
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Photo")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                        
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .cornerRadius(8)
                        }
                        
                        Button("Submit") {
                            let comment = Comment(
                                author: "You",
                                text: newComment,
                                rating: newRating,
                                timestamp: Date(),
                                image: selectedImage,
                                isCurrentUser: true,
                                likes: 0
                            )
                            comments.append(comment)
                            newComment = ""
                            newRating = 0
                            selectedImage = nil
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(.ultraThickMaterial)
                }
            }
            .navigationTitle("Comments")
        }
        
        // select photo
        .photosPicker(isPresented: $showImagePicker, selection: Binding(get: {
            nil
        }, set: { newItem in
            Task {
                if let item = newItem,
                   let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                }
            }
        }))
    }
    
    // MARK: for each comment
    struct CommentCard: View {
        let comment: Comment
        let onDelete: () -> Void
        let onLike: () -> Void
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(comment.author).bold()
                        Spacer()
                        Text(comment.timestamp, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        if comment.isCurrentUser {
                            Button(action: onDelete) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { i in
                            Image(systemName: i <= comment.rating ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    Text(comment.text)
                    
                    if let image = comment.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .cornerRadius(8)
                    }
                    
                    // MARK: - like and the number of likes
                    HStack(spacing: 4) {
                        Button(action: onLike) {
                            Image(systemName: "hand.thumbsup")
                        }
                        .buttonStyle(.plain)
                        
                        Text("\(comment.likes)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 6)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}
// MARK: - Preview
#Preview {
    CommentSectionView(parkingSpotID: "test123")
}

