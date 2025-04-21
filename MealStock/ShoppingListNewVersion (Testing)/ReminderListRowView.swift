import SwiftUI
import SwiftData

struct ReminderListRowView: View {
    @Bindable var reminderList: ItemList
    
    var body: some View {
        HStack {
            Text(reminderList.name)
            Spacer()
            Text("\(reminderList.reminder.count)")
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ItemList.self, configurations: config)
        let example = ItemList(name: "App Team", reminder: [ListIem(name: "Talk to Same"), ListIem(name: "Collect bounty")])
        
        return ReminderListRowView(reminderList: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
