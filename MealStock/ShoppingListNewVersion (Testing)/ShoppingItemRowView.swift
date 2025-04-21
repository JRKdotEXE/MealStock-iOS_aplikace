import SwiftUI
import SwiftData

struct ShoppingItemRowView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var reminder: ListIem
    
    var body: some View {
        HStack {
            Button {
                reminder.isCompleted.toggle()
            } label: {
                if reminder.isCompleted {
                    filledReminderLabel
                } else {
                    emptyReminderLabel
                }
            }
            .frame(width: 20, height: 20)
            .buttonStyle(.plain)
            
            TextField(reminder.name, text: $reminder.name)
                .foregroundStyle(reminder.isCompleted ? .darkgreen : .accentbrown)
                .strikethrough(reminder.isCompleted)
                .fontWeight(.semibold)
            
            
        }
        .background(.mainer)
    }
    
    var filledReminderLabel: some View {
        Circle()
            .stroke(.primary, lineWidth: 2)
            .overlay(alignment: .center) {
                GeometryReader { geo in
                    VStack {
                        Circle()
                            .fill(.darkgreen)
                            .frame(width: geo.size.width*0.7, height: geo.size.height*0.7, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
    }
    
    var emptyReminderLabel: some View {
        Circle()
            .stroke(.darkgreen)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ListIem.self, configurations: config)
        let example = ListIem(name: "Reminder Example", isCompleted: false)
        
        return ShoppingItemRowView(reminder: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
