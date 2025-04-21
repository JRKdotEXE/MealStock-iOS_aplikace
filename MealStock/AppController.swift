//
//  AppController.swift
//  MealStock_koncept-v1
//
//  Created by Jiří on 05.05.2024.
//
import FirebaseAuth
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

enum AuthState {
    case undefined, authenticated, notAuthenticated
}

@MainActor
class AppController: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var authState: AuthState = .undefined
    @Published var currentUser: User?
    @ObservedObject var userViewModel: UserViewModel = UserViewModel()
    @Published var currentMealPlanPost: Post?
    private let db = Firestore.firestore()
    
    init() {
        listenToAuthChanges()
    }

    func listenToAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            Task {
                try? await user?.reload()
                self.authState = user != nil ? .authenticated : .notAuthenticated
                self.username = user?.displayName ?? ""
                self.currentUser?.currentMealPlanPostId = ""
            }
        }
    }

    @MainActor
    func signUp() async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)

        if !username.isEmpty {
            try await result.user.updateProfile(\.displayName, to: username.lowercased())
        }

        try await result.user.reload()

        self.username = result.user.displayName ?? ""
        self.currentUser = User(
            id: result.user.uid,
            username: self.username,
            userBio: "",
            userBioLink: "",
            userEmail: self.email,
            currentMealPlanPostId: ""
        )
    }
	
    @MainActor
    func signIn() async throws {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
        self.currentUser = try await fetchCurrentUser()
        self.username = self.currentUser?.username ?? ""
    }

    @MainActor
    func signOut() throws {
        try Auth.auth().signOut()
        self.authState = .notAuthenticated
        self.username = ""
    }
    
    @MainActor	
    func updateUserProfile(_ username: String) {
            self.currentUser?.username = username
            self.username = username
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: { err in
                if let err {
                    print(err.localizedDescription)
                }
            })
        }
    
    func deleteUser() {
        let user = Auth.auth().currentUser
        
        user?.delete(completion: { err in
            if let err {
                print(err.localizedDescription)
            }
        })
    }

    @MainActor
    func saveCurrentMealPlanPost(_ postId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userId).updateData(["currentPostId": postId]) { error in
            if let error = error {
                print("Error saving current meal plan post: \(error.localizedDescription)")
            } else {
                self.currentUser?.currentMealPlanPostId = postId
                print("Successfully saved current meal plan post: \(postId)")
            }
        }
    }

    @MainActor
    func fetchCurrentMealPlanPost() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            if let postId = document.data()?["currentMealPlanPostId"] as? String {
                let postDocument = try await db.collection("posts").document(postId).getDocument()
                self.currentMealPlanPost = try postDocument.data(as: Post.self)
            }
        } catch {
            print("Error fetching current meal plan post: \(error.localizedDescription)")
        }
    }
    
    private func fetchCurrentUser() async throws -> User? {
        guard let userId = Auth.auth().currentUser?.uid else { return nil }
        let db = Firestore.firestore()
        let document = try await db.collection("users").document(userId).getDocument()
        return try document.data(as: User.self)
    }

    @MainActor
    func updateBio(_ bio: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User ID is not existing.")
            return
        }
        
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            if document?.exists == true {
                userRef.updateData(["userBio": bio]) { error in
                    if let error = error {
                        print("Error updating bio: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            self.currentUser?.userBio = bio
                        }
                    }
                }
            } else {
                print("User document does not exist.")
            }
        }
    }
}

private extension FirebaseAuth.User {
    func updateProfile<T>(_ keyPath: WritableKeyPath<UserProfileChangeRequest, T>, to newValue: T) async throws {
        var changeRequest = createProfileChangeRequest()
        changeRequest[keyPath: keyPath] = newValue
        try await changeRequest.commitChanges()
    }
}

extension AppController {
    func followUser(followerId: String, followingId: String) {
            let db = Firestore.firestore()
            let followingRef = db.collection("users").document(followerId).collection("following")

            followingRef.document(followingId).setData(["userId": followingId]) { error in
                if let error = error {
                    print("Error following user: \(error.localizedDescription)")
                } else {
                    print("Successfully followed user: \(followingId)")
                }
            }
        }

        func fetchFollowingPosts(userId: String, completion: @escaping ([Post]) -> Void) {
            let db = Firestore.firestore()
            let followingRef = db.collection("users").document(userId).collection("following")

            followingRef.getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching following users: \(error.localizedDescription)")
                    completion([])
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }

                let followingIds = documents.map { $0.documentID }

                db.collection("posts").whereField("userId", in: followingIds).getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching posts: \(error.localizedDescription)")
                        completion([])
                        return
                    }

                    let posts = snapshot?.documents.compactMap { try? $0.data(as: Post.self) } ?? []
                    completion(posts)
                }
            }
        }
    
}
