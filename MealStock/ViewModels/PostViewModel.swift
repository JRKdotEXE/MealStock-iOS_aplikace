//
//  PostsViewModel.swift
//  MealStock
//
//  Created by Jiří on 03.10.2024.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class PostViewModel: ObservableObject {
    @Published var posts = [Post]()
        private var db = Firestore.firestore()

        func fetchPosts() {
            db.collection("posts").order(by: "timestamp", descending: true).addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching posts: \(error.localizedDescription)")
                } else {
                    self.posts = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: Post.self)
                    } ?? []
                }
            }
        }

    func addRecipePost(title: String, content: String, username: String, calories: Int, protein: Int, carbs: Int, fat: Int, ingredients: [Ingredient], instructions: [String], imageUrl: String?, tags: [String] = [], category: Recipe.Category) {
        let postId = UUID().uuidString
        let post = Post(
            id: postId,
            title: title,
            content: content,
            username: username,
            timestamp: Date(),
            type: .recipe,
            imageUrl: imageUrl,
            recipe: Recipe(name: title, description: content, author: username, ingredients: ingredients, category: category, instructions: instructions, calories: calories, protein: protein, carbs: carbs, fat: fat),
            tags: tags
        )
        do {
            try db.collection("posts").document(postId).setData(from: post)
            db.collection("posts").document(postId).updateData(["keyWords": post.keyWords])
        } catch {
            print("Error adding post: \(error.localizedDescription)")
        }
    }
    
    func deleteRecipePost(withId id: String) {
        db.collection("posts").document(id).delete()
    }
    
    ///FIX
    func addMealPlanPost(title: String, content: String, mealPlan: MealPlan, username: String, imageUrl: String?, tags: [String]) {
        let postId = UUID().uuidString
        let mealPlanPost = Post(
            id: postId,
            title: title,
            content: content,
            username: username,
            timestamp: Date(),
            type: .mealPlan,
            imageUrl: imageUrl,
            mealPlan: mealPlan,
            tags: tags
        )
        do {
            try db.collection("posts").document(postId).setData(from: mealPlanPost)
        } catch {
            print("Error adding post: \(error.localizedDescription)")
        }
    }
    
    func addPost(title: String, content: String, username: String) {
        let newPost = Post(title: title, content: content, username: username, timestamp: Date(), type: .forumPost)
            do {
                _ = try db.collection("posts").addDocument(from: newPost)
            } catch {
                print("Error adding post: \(error.localizedDescription)")
            }
        }
    
    func deletePost(post: Post) {
        do {
            db.collection("posts").document(post.id).delete()
        }
    }
    
    func toggleLike(postId: String, userId: String) {
        let postRef = db.collection("posts").document(postId)
                
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                try postDocument = transaction.getDocument(postRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard var post = try? postDocument.data(as: Post.self) else { return nil }
            
            if post.likedBy.contains(userId) {
                post.likedBy.removeAll { $0 == userId }
                post.likes -= 1
            } else {
                
                post.likedBy.append(userId)
                post.likes += 1
            }
            
            try? transaction.setData(from: post, forDocument: postRef)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error updating like: \(error)")
            }
        }
    }

    func checkIfPostLiked(postId: String) -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else { return false }
        if let post = posts.first(where: { $0.id == postId }) {
            return post.likedBy.contains(userId)
        }
        return false
    }

    func listenToPostLikes(postId: String) {
        db.collection("posts").document(postId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching post: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if let post = try? document.data(as: Post.self) {
                    if let index = self.posts.firstIndex(where: { $0.id == postId }) {
                        self.posts[index] = post
                    }
                }
            }
    }

    func getLikedPosts(type: PostType) -> [Post] {
        guard let userId = Auth.auth().currentUser?.uid else { return [] }
        return posts.filter { post in
            post.typ == type && post.likedBy.contains(userId)
        }
    }

    func addComment(postId: String, content: String, author: String, authorId: String = "") {
        let comment = Comment(content: content, author: author)
        
        db.collection("posts").document(postId).updateData([
            "comments": FieldValue.arrayUnion([[
                "id": comment.id,
                "content": comment.content,
                "author": comment.author,
                "authorId": authorId,
                "timestamp": Timestamp(date: comment.timestamp)
            ]])
        ]) { error in
            if let error = error {
                print("Error adding comment: \(error.localizedDescription)")
            }
        }
    }

    func fetchComments(postId: String, completion: @escaping ([Comment]) -> Void) {
        db.collection("posts").document(postId).getDocument { document, error in
            if let document = document, document.exists {
                if let commentsData = document.data()?["comments"] as? [[String: Any]] {
                    let comments = commentsData.compactMap { commentDict -> Comment? in
                        guard 
                            let id = commentDict["id"] as? String,
                            let content = commentDict["content"] as? String,
                            let author = commentDict["author"] as? String,
                            let timestamp = commentDict["timestamp"] as? Timestamp
                        else { return nil }
                        
                        return Comment(id: id, content: content, author: author)
                    }
                    completion(comments)
                }
            }
        }
    }
}
