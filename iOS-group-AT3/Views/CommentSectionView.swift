//
//  CommentSectionView.swift
//  iOS-group-AT3
//
//  Created by Chao Wan on 9/5/2025.
//
import UIKit
import SwiftUI
import PhotosUI

struct CommentSectionView: View {
    let parkingSpotID: String
    
    @State private var comments: [Comment] = []
    @State private var newComment = ""
    @State private var newRating = 0
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @Environment(\.dismiss) var dismiss
    
    var averageRating: Double {
        let total = comments.reduce(0) { $0 + $1.rating }
        return comments.isEmpty ? 0.0 : Double(total) / Double(comments.count)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                //  Header
                HStack {
                    Button(action: { dismiss() }) {
                        Label("Back", systemImage: "chevron.left")
                    }
                    Spacer()
                }
                .padding()
                
                //  Title
                Text("Comments for \(parkingSpotID)")
                    .font(.title2).bold()
                Text("⭐️ Average Rating: \(String(format: "%.1f", averageRating))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 6)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(comments) { comment in
                            CommentCard(comment: comment, onDelete: {
                                comments.removeAll { $0.id == comment.id }
                            }, onLike: {
                                if let i = comments.firstIndex(where: { $0.id == comment.id }) {
                                    comments[i].likes += 1
                                }
                            }, onReply: { reply in
                                if let i = comments.firstIndex(where: { $0.id == comment.id }) {
                                    comments[i].replies.append(reply)
                                }
                            })
                        }
                        
                        if comments.isEmpty {
                            Text("No comments yet.")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                }
                
                //  Input Area
                VStack(spacing: 10) {
                    HStack {
                        Text("Rate:")
                        ForEach(1...5, id: \.self) { i in
                            Image(systemName: i <= newRating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture { newRating = i }
                        }
                    }
                    
                    TextEditor(text: $newComment)
                        .frame(height: 80)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.3)))
                    
                    Button {
                        showImagePicker = true
                    } label: {
                        Label("Add Photo", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .cornerRadius(6)
                    }
                    
                    Button("Submit") {
                        let new = Comment(
                            author: "You",
                            text: newComment,
                            rating: newRating,
                            timestamp: Date(),
                            likes: 0,
                            replies: [],
                            image: selectedImage,
                            isCurrentUser: true
                        )
                        comments.append(new)
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
            }
        }
        .onAppear {
            loadComments(for: parkingSpotID)
        }
        .photosPicker(isPresented: $showImagePicker, selection: .constant(nil))
    }
    
    // MARK: - Load comments from JSON
    func loadComments(for spotID: String) {
        guard let url = Bundle.main.url(forResource: "comments", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("comments.json not found")
            return
        }
        
        do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decoded = try decoder.decode([String: [Comment]].self, from: data)
                comments = decoded[spotID] ?? []
                print("Loaded \(comments.count) comment(s) for: \(spotID)")
            } catch {
                print("Failed to decode comments.json: \(error)")
        }
    }
    
    // MARK: - Comment card
    struct CommentCard: View {
        let comment: Comment
        let onDelete: () -> Void
        let onLike: () -> Void
        let onReply: (Reply) -> Void
        
        @State private var replyText = ""
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(comment.author).bold()
                    Spacer()
                    Text(comment.timestamp, style: .date).font(.caption)
                    
                    if comment.isCurrentUser {
                        Button(action: onDelete) {
                            Image(systemName: "trash").foregroundColor(.red)
                        }
                    }
                }
                
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { i in
                        Image(systemName: i <= comment.rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.footnote)
                    }
                }
                
                Text(comment.text)
                
                if let image = comment.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .cornerRadius(6)
                }
                
                HStack {
                    Button(action: onLike) {
                        Image(systemName: "hand.thumbsup")
                    }
                    Text("\(comment.likes)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                ForEach(comment.replies) { reply in
                    VStack(alignment: .leading) {
                        Text("\(reply.author) \(reply.timestamp, style: .time)")
                            .font(.caption).bold()
                        Text(reply.text).font(.caption)
                    }
                    .padding(.leading, 20)
                }
                
                TextEditor(text: $replyText)
                    .frame(height: 40)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.3)))
                
                Button("Send Reply") {
                    let reply = Reply(author: "You", text: replyText, timestamp: Date())
                    onReply(reply)
                    replyText = ""
                }
                .disabled(replyText.trimmingCharacters(in: .whitespaces).isEmpty)
                .font(.caption)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
}
