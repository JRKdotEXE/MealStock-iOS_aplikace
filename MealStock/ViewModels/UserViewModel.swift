//
//  UserViewModel.swift
//  MealStock
//
//  Created by Jiří on 20.01.2025.
//
import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var currentUser: User?
    @EnvironmentObject private var appController: AppController
    
    private let db = Firestore.firestore()
    
    init() {
        fetchUsers()
    }
    
    func fetchUsers() {
        db.collection("users").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching users: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.users = documents.compactMap { doc -> User? in
                try? doc.data(as: User.self)
            }
        }
    }
    
    func addUser(id: String?, username: String, userBio: String, userBioLink: String, userEmail: String, profileImageUrl: String? = nil, currentPostId: String? = nil, currentMealPlanPostId: String? = nil) {
        let user = User(
            id: id ?? UUID().uuidString,
            username: username,
            userBio: userBio,
            userBioLink: userBioLink,
            userEmail: userEmail,
            profileImageUrl: profileImageUrl,
            currentPostId: currentPostId,
            currentMealPlanPostId: currentMealPlanPostId
        )
        do {
            try db.collection("users").document(user.id).setData(from: user)
        } catch {
            print("Error adding user: \(error.localizedDescription)")
        }
    }
    
    func follow(userToFollow: User) {
        guard let currentUserID = currentUser?.id else { return }
        
        let currentUserRef = db.collection("users").document(currentUserID)
        currentUserRef.updateData([
            "following": FieldValue.arrayUnion([userToFollow.id])
        ])
        
        let userToFollowRef = db.collection("users").document(userToFollow.id)
        userToFollowRef.updateData([
            "followers": FieldValue.arrayUnion([currentUserID])
        ])
    }
    
    func unfollow(userToUnfollow: User) {
        guard let currentUserID = currentUser?.id else { return }
        
        let currentUserRef = db.collection("users").document(currentUserID)
        currentUserRef.updateData([
            "following": FieldValue.arrayRemove([userToUnfollow.id])
        ])
        
        let userToUnfollowRef = db.collection("users").document(userToUnfollow.id)
        userToUnfollowRef.updateData([
            "followers": FieldValue.arrayRemove([currentUserID])
        ])
    }
    
    func isUsernameTaken(_ username: String) async -> Bool {
        do {
            let snapshot = try await db.collection("users")
                .whereField("username", isEqualTo: username.lowercased())
                .getDocuments()
            return !snapshot.documents.isEmpty
        } catch {
            print("Error checking username: \(error.localizedDescription)")
            return false
        }
    }
}
