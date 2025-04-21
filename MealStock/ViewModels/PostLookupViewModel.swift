//
//  PostLookupViewModel.swift
//  MealStock
//
//  Created by Jiří on 31.03.2025.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class PostLookupViewModel: ObservableObject {
    
    @Published var queriedPosts: [Post] = []
    
    private let db = Firestore.firestore()
    
    func fetchPosts(from keyword: String) {
        db.collection("posts")
            .whereField("tags", arrayContains: keyword.lowercased())
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else { return }
                self.queriedPosts = documents.compactMap { queryDocSnapshot in
                    try? queryDocSnapshot.data(as: Post.self)
                }
            }
    }
}
