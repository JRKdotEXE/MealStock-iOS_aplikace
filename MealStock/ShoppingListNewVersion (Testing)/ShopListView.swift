import SwiftUI
import SwiftData

struct ShopListView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var reminderList: ItemList

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 5) {
                List {
                    ForEach(reminderList.reminder) { reminders in
                        ShoppingItemRowView(reminder: reminders)
                            .listRowBackground(Color.mainer)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.inset)
                .scrollContentBackground(.hidden)
                .listRowBackground(Color.mainer)
            }
            .foregroundStyle(Color("darkgreen"))
            .background(Color.mainer)
            .navigationTitle("Shopping List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Shopping List")
                        .foregroundStyle(Color("darkgreen"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
            .navigationBarColor(backgroundColor: .main, titleColor: .darkgreen)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        reminderList.reminder.append(ListIem(name: ""))
                    } label: {
                        HStack(spacing: 7) {
                            Image(systemName: "plus.circle.fill")
                            Text("New Reminder")
                        }
                        .font(.system(.body, design: .rounded))
                        .bold()
                        .foregroundStyle(.darkgreen)
                    }
                    Spacer()
                }
            }
        }
    }
    
    func delete(_ indexSet: IndexSet) {
        for index in indexSet {
            reminderList.reminder.remove(at: index)
        }
        try! modelContext.save()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ItemList.self, configurations: config)
        let example = ItemList(name: "Shopping list", reminder: [])
        
        return ShopListView(reminderList: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
