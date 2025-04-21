//
//  AddRecipeView.swift
//  MealStock
//
//  Created by Jiří on 13.07.2024.
//
import SwiftUI
import FirebaseStorage

struct AddRecipeView: View {
    @State private var content = ""
    @State private var title = ""
    @State private var selectedImage: UIImage? = UIImage(named: "LogoBackground")
    @State private var imageUrl: String? = nil
    @State private var isImagePickerPresented = false
    @ObservedObject var postViewModel = PostViewModel()
    @State private var instructionsCount: Int = 0
    @State private var ingredientsCount: Int = 0
    @State private var contents: [String] = []
    @State private var tags: [String] = []
    @State private var tagsCount: Int = 0
    @State var finalIngredients: [Ingredient] = []
    @EnvironmentObject private var appController: AppController
    @Environment(\.dismiss) var dismiss
    @StateObject var tagViewModel: TagViewModel = TagViewModel()
    @State var calories: Int = 0
    @State var protein: Int = 0
    @State var carbs: Int = 0
    @State var fat: Int = 0
    @State var category: Recipe.Category = .any
    private let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
    }()
    
    @State private var showingAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Add Your Recipe")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .foregroundStyle(.accentbrown)
                    .padding([.top, .leading, .trailing], 15)
                
                Form {
                    Section() {
                        HStack {
                            Spacer()
                            Button(action: {
                                isImagePickerPresented = true
                            }) {
                                Text("Select Image")
                                    .multilineTextAlignment(.center)
                            }
                            .sheet(isPresented: $isImagePickerPresented) {
                                ImagePicker(selectedImage: $selectedImage)
                            }
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            }
                            Spacer()
                        }
                    }
                    
                    Section("Title") {
                        TextField("Title", text: $title)
                    }
                    
                    Section("Description") {
                        TextEditor(text: $content)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                    }
                    
                    Section("Tags") {
                        Button {
                            tagsCount += 1
                            tags.append("")
                        } label: {
                            Text("Add Tag")
                        }
                        ForEach(0..<tags.count, id: \.self) { i in
                            TextField("Write your tag", text: $tags[i])
                                .textInputAutocapitalization(.never)
                        }
                    }
                    
                    Section("Category") {
                        Picker("Select a category", selection: $category) {
                            Text("Anytime").tag(Recipe.Category.any)
                            Text("Breakfast").tag(Recipe.Category.breakfast)
                            Text("Lunch").tag(Recipe.Category.lunch)
                            Text("Dinner").tag(Recipe.Category.dinner)
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundStyle(.secondary)
                    }
                    
                    Section("Ingredients") {
                        Button {
                            ingredientsCount += 1
                            finalIngredients.append(Ingredient(name: "", quantity: 0, unit: .none))
                        } label: {
                            Text("Add Ingredient")
                        }
                        ForEach(0..<ingredientsCount, id: \.self) { index in
                            IngredientsField(index: index, text: $finalIngredients[index].name, quantity: $finalIngredients[index].quantity, unit: $finalIngredients[index].unit)
                        }
                    }
                    
                    Section("Instructions") {
                        Button {
                            instructionsCount += 1
                            contents.append("")
                        } label: {
                            Text("Add Step")
                        }
                        ForEach(0..<instructionsCount, id: \.self) { index in
                            TextField("\(index + 1). step", text: $contents[index])
                        }
                    }
                    
                    Section("Calories") {
                        HStack {
                            TextField("", value: $calories, formatter: numberFormatter)
                                .keyboardType(.decimalPad)
                            Text("kcal")
                                .foregroundStyle(.secondary)
                        }
                    }
                        
                    Section("Protein") {
                        NumericInputField(title: "Protein", value: $protein, formatter: numberFormatter)
                    }
                    
                    Section("Carbs") {
                        NumericInputField(title: "Carbs", value: $carbs, formatter: numberFormatter)
                    }
                    
                    Section("Fat") {
                        NumericInputField(title: "Fat", value: $fat, formatter: numberFormatter)
                    }
                    
                    Button {
                        if title == "" {
                            showingAlert = true
                        } else {
                            uploadImageAndSavePost()
                        }
                    } label: {
                        Text("CREATE RECIPE")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("accentbrown"))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .foregroundStyle(.white)
                    }
                    .alert("Something's missing in your recipe!", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.mainer)
                
            }
            .background(Color.mainer)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("")
                        .font(.largeTitle)
                }
            }
            .navigationBarTitleDisplayMode(.automatic)
            .toolbarBackground(Color("mainColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    private func uploadImageAndSavePost() {
            guard let selectedImage = selectedImage else {
                savePost(imageUrl: nil)
                return
            }
            
            let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
            if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                storageRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        print("Error uploading image: \(error)")
                        return
                    }
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            print("Error getting download URL: \(error)")
                            return
                        }
                        savePost(imageUrl: url?.absoluteString)
                    }
                }
            }
        }
        
    private func savePost(imageUrl: String?) {
        for i in 0..<tagsCount {
            tags[i] = tags[i].trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        }

        tagViewModel.fetchAllTags()

        let newTags = tags.filter { tag in
            !tag.isEmpty && !tagViewModel.queriedTags.contains(tag)
        }

        for tag in newTags {
            tagViewModel.addTag(tag)
        }

        postViewModel.addRecipePost(
            title: title,
            content: content,
            username: appController.username,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat,
            ingredients: finalIngredients,
            instructions: contents,
            imageUrl: imageUrl,
            tags: tags,
            category: category
        )

        dismiss()
    }

}

struct NumericInputField: View {
    let title: String
    @Binding var value: Int
    let formatter: NumberFormatter
    @State private var pick: Unit = .g
    
    var body: some View {
        HStack {
            TextField(title, value: $value, formatter: formatter)
                .keyboardType(.decimalPad)
            Picker("", selection: $pick) {
                Text("oz").tag(Unit.oz)
                    .foregroundStyle(.secondary)
                Text("grams").tag(Unit.g)
                    .foregroundStyle(.secondary)
            }
            .foregroundStyle(.secondary)
        }
    }
}

struct IngredientsField: View {
    var index: Int
    @Binding var text: String
    @Binding var quantity: Double
    @Binding var unit: Unit
    
    private let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
    }()
    
    var body: some View {
        HStack {
            TextField("\(index + 1). ingredient", text: $text)
            TextField("", value: $quantity, formatter: numberFormatter)
                .keyboardType(.decimalPad)
            Text("Unit:")
            Picker("", selection: $unit) {
                Text("-").tag(Unit.none)
                Text("oz").tag(Unit.oz)
                Text("grams").tag(Unit.g)
                Text("cups").tag(Unit.cups)
                Text("tbsp").tag(Unit.tbsp)
                Text("tsp").tag(Unit.tsp)
                Text("ml").tag(Unit.ml)
            }.frame(maxWidth: 50)
        }
    }
    
}
#Preview {
    AddRecipeView().environmentObject(AppController())
}

