import SwiftUI
import SwiftData

struct CreateSectionView: View {
    @Bindable var reminderList: ItemList
    
    var body: some View {
        Form {
            TextField("Name", text: $reminderList.name)
            }
        
        .navigationTitle("Add Segment")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CreateSectionView(reminderList: ItemList(name: "", reminder: []))
}
