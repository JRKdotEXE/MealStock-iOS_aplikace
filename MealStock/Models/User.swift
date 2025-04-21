import SwiftUI
import FirebaseFirestoreSwift

class User: Identifiable, Codable {
    var id: String = UUID().uuidString
    var username: String
    var userBio: String
    var userBioLink: String
    var userEmail: String
    var profileImageUrl: String?
    var issignedIn: Bool = false
    var followers: [User] = []
    var following: [User] = []
    var currentPostId: String? = nil
    var currentMealPlanPostId: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case userBio
        case userBioLink
        case userEmail
        case profileImageUrl
        case currentPostId
        case currentMealPlanPostId
    }
    
    init(id: String = UUID().uuidString, username: String, userBio: String, userBioLink: String, userEmail: String, profileImageUrl: String? = nil, currentPostId: String? = nil, currentMealPlanPostId: String? = nil) {
        self.id = id
        self.username = username
        self.userBio = userBio
        self.userBioLink = userBioLink
        self.userEmail = userEmail
        self.profileImageUrl = profileImageUrl
        self.currentPostId = currentPostId
        self.currentMealPlanPostId = currentMealPlanPostId
    }
}
