//
//  MealStockShoppingListView.swift
//  MealStock_koncept-v1
//
//  Created by Jiří on 30.12.2023.
//
import SwiftUI
import SwiftData

struct ShoppingListView: View {
    @Query var shoppingItems: [ShoppingItem]
        @Environment(\.modelContext) private var modelContext

        @State private var itemName: String = ""
        @State private var itemQuantity: String = ""
        @State private var itemUnit: String = ""

        var body: some View {
            NavigationView {
                VStack {
                    List {
                        ForEach(shoppingItems) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text("\(item.quantity, specifier: "%.2f") \(item.unit)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())

                    Divider()

                    VStack(spacing: 12) {
                        TextField("Item Name", text: $itemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Quantity", text: $itemQuantity)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                        TextField("Unit (e.g., kg, ml, pieces)", text: $itemUnit)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button("Add Item") {
                            addItem()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 8))
                    }
                    .padding()
                }
                .navigationTitle("Shopping List")
            }
            .onAppear {
                print("Loaded \(shoppingItems.count) items")
            }
        }

        private func addItem() {
            guard let quantity = Double(itemQuantity), !itemName.isEmpty, !itemUnit.isEmpty else { return }
            let newItem = ShoppingItem(name: itemName, quantity: quantity, unit: itemUnit)
            modelContext.insert(newItem)
            print("Inserted new item: \(itemName) \(quantity) \(itemUnit)")
            itemName = ""
            itemQuantity = ""
            itemUnit = ""
        }
    
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(shoppingItems[index])
        }
    }
}

#Preview {
    ShoppingListView()
        .modelContainer(for: [ShoppingItem.self], inMemory: true)
}

//@MainActor
//struct ShoppingListView: View {
//    @Environment(\.modelContext) var modelContext
//    @Bindable var shoppingList: ShoppingList
//
//
//    @State private var goods = ["Eggs", "Salmon", "Garlic"]
//    @State var text = ""
//
//    var body: some View {
//        NavigationStack {
//                VStack {
//                   // HStack {
//                   //     TextField("Add something to the list", text: self.$text)
//                   //         .textFieldStyle(RoundedBorderTextFieldStyle())
//                   //
//                   //     Button(action: {
//                   //         if !self.text.isEmpty {
//                   //             self.goods.append(self.text)
//                   //             self.text = ""
//                   //         }
//                   //     }, label: {
//                   //         Text("Add")
//                   //     })
//                   // }
//                   // .padding()
//                   // ForEach(goods, id: \.self) { good in
//                   //     MealItem(item: good)
//                   // }
//                    HStack {
//                        Text("Shopping list")
//                        Spacer()
//                        Text("\(shoppingList.items.count) items")
//                    }
//                     List {
//                         ForEach(shoppingList.items) { item in
//                             ListItem(good: item.name, onRemove: {
//                                 if let index = goods.firstIndex(of: item.name) {
//                                     goods.remove(at: index)
//                                 }
//                             })
//                         }
//                     }
//                    .navigationTitle("Shopping list")
//                    .navigationBarTitleDisplayMode(.inline)
//                    .navigationBarColor(backgroundColor: .main, titleColor: .darkgreen)
//                    .background(Color("mainerColor"))
//                    .toolbar {
//                        ToolbarItemGroup(placement: .bottomBar) {
//                            Button {
//                                shoppingList.items.append(ShoppingItem(name: "", //isComplete: false))
//                            } label: {
//                                Image(systemName: "plus")
//                                    .foregroundStyle(.primary)
//                            }
//                        }
//                    }
//                }.background(Color("mainerColor"))
//
//        }
//    }
//}

/*#Preview {
        let container = try ModelContainer(for: ShoppingList.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
    ShoppingListView(shoppingList: ShoppingList(name: "Shopping List", iconName: "list.bullet", items: [ShoppingItem(name: "Bananas", isComplete: false)]))
            .modelContainer(container)
} */

//struct MySwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        do {
//            let container = try ModelContainer(for: ShoppingList.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//
//            ShoppingListView(shoppingList: ShoppingList(name: "Shopping List", iconName: "list.bullet", items: [ShoppingItem(name: "Bananas", isComplete: false)]))
//                .modelContainer(container)
//        } catch {
//            fatalError("Could not load preview data: \(error)")
//        }
//    }
//}

//struct MySwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            if let container = createContainer() {
//                ShoppingListView(
//                    shoppingList: ShoppingList(name: "Shopping List", iconName: "list.bullet", //items: [
//                        ShoppingItem(name: "Bananas", isComplete: false)
//                    ])
//                )
//                .modelContainer(container)
//            } else {
//                Text("Error loading preview")
//                    .foregroundColor(.red)
//            }
//        }
//    }
//
//    static func createContainer() -> ModelContainer? {
//        do {
//            return try ModelContainer(
//                for: ShoppingList.self,
//                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
//            )
//        } catch {
//            print("Failed to create container: \(error)")
//            return nil
//        }
//    }
//}
