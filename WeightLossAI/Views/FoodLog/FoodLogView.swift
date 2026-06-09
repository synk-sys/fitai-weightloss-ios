import SwiftUI
import SwiftData

struct FoodLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FoodEntry.date, order: .reverse) private var entries: [FoodEntry]
    @State private var showingAdd = false
    @State private var selectedDate = Date.now

    private var todayEntries: [FoodEntry] {
        entries.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    private var groupedByMeal: [(String, [FoodEntry])] {
        let order = ["Breakfast", "Lunch", "Dinner", "Snack"]
        return order.compactMap { meal in
            let items = todayEntries.filter { $0.mealType == meal }
            return items.isEmpty ? nil : (meal, items)
        }
    }

    private var totalCalories: Int { todayEntries.reduce(0) { $0 + $1.calories } }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    HStack {
                        Label("Total calories", systemImage: "fork.knife.circle.fill")
                            .foregroundStyle(.green)
                        Spacer()
                        Text("\(totalCalories) kcal").fontWeight(.semibold)
                    }
                }

                if groupedByMeal.isEmpty {
                    ContentUnavailableView("No meals logged",
                        systemImage: "fork.knife",
                        description: Text("Tap + to add a meal"))
                } else {
                    ForEach(groupedByMeal, id: \.0) { meal, items in
                        Section(meal) {
                            ForEach(items) { item in
                                foodRow(item)
                            }
                            .onDelete { offsets in deleteItems(items: items, offsets: offsets) }
                        }
                    }
                }
            }
            .navigationTitle("Food Log")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddFoodView(date: selectedDate)
            }
        }
    }

    private func foodRow(_ entry: FoodEntry) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.name).fontWeight(.medium)
                Spacer()
                Text("\(entry.calories) kcal")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            HStack(spacing: 12) {
                macroChip("P", value: entry.proteinG, color: .blue)
                macroChip("C", value: entry.carbsG, color: .orange)
                macroChip("F", value: entry.fatG, color: .red)
            }
        }
        .padding(.vertical, 2)
    }

    private func macroChip(_ label: String, value: Double, color: Color) -> some View {
        Text("\(label) \(String(format: "%.0f", value))g")
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    private func deleteItems(items: [FoodEntry], offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}
