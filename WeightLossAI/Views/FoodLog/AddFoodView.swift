import SwiftUI
import SwiftData

struct AddFoodView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let date: Date

    @State private var name = ""
    @State private var calories = ""
    @State private var protein = ""
    @State private var carbs = ""
    @State private var fat = ""
    @State private var mealType = "Breakfast"

    private let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Meal Info") {
                    TextField("Food name", text: $name)
                    Picker("Meal", selection: $mealType) {
                        ForEach(mealTypes, id: \.self) { Text($0) }
                    }
                }
                Section("Nutrition") {
                    numberField("Calories (kcal)", text: $calories)
                    numberField("Protein (g)", text: $protein)
                    numberField("Carbs (g)", text: $carbs)
                    numberField("Fat (g)", text: $fat)
                }
            }
            .navigationTitle("Add Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(name.isEmpty || calories.isEmpty)
                }
            }
        }
    }

    private func numberField(_ label: String, text: Binding<String>) -> some View {
        HStack {
            Text(label)
            Spacer()
            TextField("0", text: text)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)
        }
    }

    private func save() {
        let entry = FoodEntry(
            date: date,
            name: name,
            calories: Int(calories) ?? 0,
            proteinG: Double(protein) ?? 0,
            carbsG: Double(carbs) ?? 0,
            fatG: Double(fat) ?? 0,
            mealType: mealType
        )
        modelContext.insert(entry)
        dismiss()
    }
}
