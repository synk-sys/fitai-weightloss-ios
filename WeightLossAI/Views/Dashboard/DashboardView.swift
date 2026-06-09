import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \FoodEntry.date, order: .reverse) private var foodEntries: [FoodEntry]
    @Query(sort: \WorkoutEntry.date, order: .reverse) private var workoutEntries: [WorkoutEntry]
    @Query private var profiles: [UserProfile]

    @State private var selectedDate = Date.now
    @State private var addFoodMeal: String? = nil

    private static let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snacks"]

    private var profile: UserProfile? { profiles.first }
    private var target: Int { profile?.dailyCalorieTarget ?? 1800 }

    private func entries(for meal: String, on date: Date) -> [FoodEntry] {
        let mealKey = meal == "Snacks" ? "Snack" : meal
        return foodEntries.filter {
            Calendar.current.isDate($0.date, inSameDayAs: date) && $0.mealType == mealKey
        }
    }

    private func calories(for meal: String, on date: Date) -> Int {
        entries(for: meal, on: date).reduce(0) { $0 + $1.calories }
    }

    private var totalCalories: Int {
        Self.mealTypes.reduce(0) { $0 + calories(for: $1, on: selectedDate) }
    }

    private var totalProtein: Double {
        foodEntries.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
            .reduce(0) { $0 + $1.proteinG }
    }
    private var totalCarbs: Double {
        foodEntries.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
            .reduce(0) { $0 + $1.carbsG }
    }
    private var totalFat: Double {
        foodEntries.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
            .reduce(0) { $0 + $1.fatG }
    }

    private var remaining: Int { max(target - totalCalories, 0) }
    private var calorieProgress: Double { min(Double(totalCalories) / Double(target), 1.0) }

    // Check if a day in the current week has any food entries
    private func hasEntries(on date: Date) -> Bool {
        foodEntries.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    // 7 days of the current week starting Sunday
    private var weekDays: [Date] {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date.now)
        let weekday = cal.component(.weekday, from: today) // 1=Sun
        let sunday = cal.date(byAdding: .day, value: -(weekday - 1), to: today)!
        return (0..<7).compactMap { cal.date(byAdding: .day, value: $0, to: sunday) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    weekStrip
                    calorieCard
                    macroCard
                    diarySection
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(item: $addFoodMeal) { meal in
            AddFoodView(date: selectedDate, preselectedMeal: meal == "Snacks" ? "Snack" : meal)
        }
    }

    // MARK: - Week Strip

    private var weekStrip: some View {
        let cal = Calendar.current
        let todayStart = cal.startOfDay(for: Date.now)
        let selectedStart = cal.startOfDay(for: selectedDate)
        let dayLetters = ["S","M","T","W","T","F","S"]

        return HStack(spacing: 0) {
            ForEach(Array(weekDays.enumerated()), id: \.offset) { i, day in
                let isToday = cal.isDate(day, inSameDayAs: todayStart)
                let isSelected = cal.isDate(day, inSameDayAs: selectedStart)
                let logged = hasEntries(on: day)
                let isPast = day < todayStart

                Button {
                    selectedDate = day
                } label: {
                    VStack(spacing: 6) {
                        Text(dayLetters[i])
                            .font(.caption2)
                            .foregroundStyle(isSelected ? .primary : .secondary)

                        ZStack {
                            if isToday {
                                Circle()
                                    .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [4]))
                                    .foregroundStyle(Color.secondary)
                                    .frame(width: 30, height: 30)
                            } else if isSelected {
                                Circle()
                                    .fill(Color.accentColor)
                                    .frame(width: 30, height: 30)
                            } else {
                                Circle()
                                    .strokeBorder(Color.secondary.opacity(0.4), lineWidth: 1)
                                    .frame(width: 30, height: 30)
                            }

                            if logged && isPast {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(isSelected ? .white : .primary)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 4)
    }

    // MARK: - Calorie Card

    private var calorieCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Calories")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(alignment: .firstTextBaseline) {
                Text("\(totalCalories)")
                    .font(.system(size: 28, weight: .bold))
                Text("cal / \(target)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(remaining)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(remaining > 0 ? Color.primary : Color.orange)
                Text("left")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(calorieProgress < 1 ? Color.accentColor : Color.orange)
                        .frame(width: geo.size.width * calorieProgress, height: 8)
                        .animation(.easeOut, value: calorieProgress)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Macro Card

    private var macroCard: some View {
        HStack(spacing: 0) {
            macroColumn(label: "Carbs", value: totalCarbs, target: 150, color: .blue)
            Divider().frame(height: 50)
            macroColumn(label: "Fat", value: totalFat, target: 60, color: .yellow)
            Divider().frame(height: 50)
            macroColumn(label: "Protein", value: totalProtein, target: 120, color: .orange)
        }
        .padding(.vertical, 12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func macroColumn(label: String, value: Double, target: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(String(format: "%.0f", value))
                    .font(.system(size: 18, weight: .bold))
                Text("g / \(Int(target))")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(.systemGray5))
                        .frame(height: 5)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color)
                        .frame(width: geo.size.width * min(value / target, 1), height: 5)
                        .animation(.easeOut, value: value)
                }
            }
            .frame(height: 5)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Diary Section

    private var diarySection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Diary")
                    .font(.title3.bold())
                Spacer()
                NavigationLink("View all") {
                    FoodLogView()
                }
                .font(.subheadline)
            }

            ForEach(Self.mealTypes, id: \.self) { meal in
                mealCard(meal: meal)
            }
        }
    }

    private func mealCard(meal: String) -> some View {
        let items = entries(for: meal, on: selectedDate)
        let cal = calories(for: meal, on: selectedDate)
        let icon = mealIcon(meal)

        return VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.blue)
                    .frame(width: 28)
                Text(meal)
                    .font(.headline)
                Spacer()
                if cal > 0 {
                    Text("\(cal) cal")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Button("Log") {
                    addFoodMeal = meal
                }
                .font(.subheadline.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Color.accentColor.opacity(0.85))
                .clipShape(Capsule())
            }
            .padding()

            if !items.isEmpty {
                Divider().padding(.horizontal)
                ForEach(items) { item in
                    HStack {
                        Text(item.name)
                            .font(.subheadline)
                        Spacer()
                        Text("\(item.calories) cal")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
            } else {
                Divider().padding(.horizontal)
                Text("Tap Log to add \(meal.lowercased())")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func mealIcon(_ meal: String) -> String {
        switch meal {
        case "Breakfast": return "cup.and.saucer.fill"
        case "Lunch":     return "takeoutbag.and.cup.and.straw.fill"
        case "Dinner":    return "fork.knife"
        default:          return "birthday.cake"
        }
    }
}

// Make String Identifiable for sheet(item:)
extension String: @retroactive Identifiable {
    public var id: String { self }
}
