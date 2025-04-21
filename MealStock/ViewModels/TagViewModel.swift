//
//  TagViewModel.swift
//  MealStock
//
//  Created by Jiří on 31.03.2025.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class TagViewModel: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var queriedTags: [String] = []
    
    func addTag(_ tag: String) {
        let tagModel = Tag(name: tag)
        
        do {
            try db.collection("tags").document(tagModel.name).setData(from: tagModel)
        } catch {
            print("Error adding tag: \(error.localizedDescription)")
        }
    }
    
    func fetchAllTags() {
        db.collection("tags")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else { return }
                self.queriedTags = documents.compactMap { queryDocSnapshot in
                    try? queryDocSnapshot.data(as: Tag.self).name
                }
            }
    }
}

struct Tag: Codable {
    var name: String
}
