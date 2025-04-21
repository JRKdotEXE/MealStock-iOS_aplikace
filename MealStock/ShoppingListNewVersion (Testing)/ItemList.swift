import Foundation
import SwiftData

@Model
final class ItemList {
    var name: String
    @Relationship(deleteRule: .cascade) var reminder = [ListIem]()
    
    init(name: String = "", reminder: [ListIem] = [ListIem]()) {
        self.name = name
        self.reminder = reminder
    }
}
