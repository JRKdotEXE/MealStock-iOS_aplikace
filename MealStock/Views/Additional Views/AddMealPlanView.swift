import SwiftUI
import FirebaseStorage

struct AddMealPlanView: View {
    @State private var description = ""
    @State private var title = ""
    @State private var daysCount = 1
    @State private var dailyMealsCount = 1
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var meals: [[Recipe]] = Array(repeating: Array(repeating: Recipe.placeholder, count: 1), count: 1)
    
    @ObservedObject var postViewModel = PostViewModel()
    @StateObject var tagViewModel: TagViewModel = TagViewModel()
    @EnvironmentObject private var appController: AppController
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedImage: UIImage? = UIImage(named: "LogoBackground")
    @State private var isImagePickerPresented = false
    @State private var imageUrl: String? = nil
    @State private var tags: [String] = []
    @State private var tagsCount: Int = 0
    @State private var showingAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Add Your Meal Plan")
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .foregroundStyle(.accentbrown)
                
                Form {
                    Section("Add image") {
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
                        TextEditor(text: $description)
                            .multilineTextAlignment(.leading)
                            .frame(height: 100)
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
                    
                    Section("Days") {
                        Stepper("\(daysCount.formatted()) days", value: $daysCount, in: 1...30, step: 1, onEditingChanged: { _ in
                            updateMealsArray()
                        })
                    }
                    
                    Section("Meals in a day") {
                        Stepper("\(dailyMealsCount.formatted()) meals per day", value: $dailyMealsCount, in: 1...9, step: 1, onEditingChanged: { _ in
                            updateMealsArray()
                        })
                    }
                    
                    ForEach(0..<daysCount, id: \.self) { dayIndex in
                        Section(header: Text("Day \(dayIndex + 1)")) {
                            ForEach(0..<dailyMealsCount, id: \.self) { mealIndex in
                                HStack {
                                    if meals[dayIndex][mealIndex].name.isEmpty {
                                        NavigationLink(destination: {
                                            AddRecipeToMealPlanView(meal: $meals[dayIndex][mealIndex])
                                        }) {
                                            Text("Add Meal")
                                                .foregroundStyle(.primary)
                                        }
                                    } else {
                                        NavigationLink(destination: {
                                            RecipeFromMealPlanView(recipe: meals[dayIndex][mealIndex])
                                        }) {
                                            Text(meals[dayIndex][mealIndex].name)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Section {
                        Button {
                            if title == "" {
                                showingAlert = true
                            } else {
                                uploadImageAndSavePost()
                            }
                        }
                        label: {
                            Text("CREATE MEAL PLAN")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("accentbrown"))
                                .cornerRadius(8)
                                .foregroundStyle(.white)
                        }
                        .alert("Something's missing in your recipe!", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color("2mainer"))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("mainColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .alert("Warning", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func updateMealsArray() {
        if daysCount > meals.count {
            meals.append(contentsOf: Array(repeating: Array(repeating: Recipe.placeholder, count: dailyMealsCount), count: daysCount - meals.count))
        } else if daysCount < meals.count {
            meals.removeLast(meals.count - daysCount)
        }
        
        for dayIndex in 0..<daysCount {
            if dailyMealsCount > meals[dayIndex].count {
                meals[dayIndex].append(contentsOf: Array(repeating: Recipe.placeholder, count: dailyMealsCount - meals[dayIndex].count))
            } else if dailyMealsCount < meals[dayIndex].count {
                meals[dayIndex].removeLast(meals[dayIndex].count - dailyMealsCount)
            }
        }
    }
    
    private func createMealPlan(imageUrl: String?) {
        let days = meals.enumerated().map { Day(name: "Day \($0.offset + 1)", recipes: $0.element) }
        let mealPlan = MealPlan(name: title, days: days, description: description)
        
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
        
        postViewModel.addMealPlanPost(
            title: title,
            content: description,
            mealPlan: mealPlan,
            username: appController.username,
            imageUrl: imageUrl,
            tags: tags
        )
        dismiss()
    }
    
    private func uploadImageAndSavePost() {
            guard let selectedImage = selectedImage else {
                createMealPlan(imageUrl: nil)
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
                        createMealPlan(imageUrl: url?.absoluteString)
                    }
                }
            }
        }
}

#Preview {
    AddMealPlanView()
        .environmentObject(AppController())
}
