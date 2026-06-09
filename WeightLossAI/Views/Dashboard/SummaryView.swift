import SwiftUI
import SwiftData

struct SummaryView: View {
    @Query(sort: \WeightEntry.date, order: .reverse) private var weightEntries: [WeightEntry]
    @Query(sort: \FoodEntry.date, order: .reverse) private var foodEntries: [FoodEntry]
    @Query(sort: \WorkoutEntry.date, order: .reverse) private var workoutEntries: [WorkoutEntry]
    @Query private var profiles: [UserProfile]

    private var profile: UserProfile? { profiles.first }
    @State private var showingUnitPrefs = false

    private var todayCalories: Int {
        foodEntries.filter { Calendar.current.isDateInToday($0.date) }
            .reduce(0) { $0 + $1.calories }
    }
    private var todayBurned: Int {
        workoutEntries.filter { Calendar.current.isDateInToday($0.date) }
            .reduce(0) { $0 + $1.caloriesBurned }
    }
    private var currentWeight: Double? { weightEntries.first?.weightKg }
    private var target: Int { profile?.dailyCalorieTarget ?? 1800 }
    private var remaining: Int { max(target - todayCalories, 0) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    greetingCard
                    statsGrid
                    weightCard
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showingUnitPrefs = true } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingUnitPrefs) {
                if let p = profile {
                    UnitPreferencesView(profile: p)
                }
            }
        }
    }

    private var greetingCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hello, \(profile?.name ?? "there") 👋")
                    .font(.title2.bold())
                Text(Date.now.formatted(date: .complete, time: .omitted))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "figure.walk.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.green)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            statCard(title: "Consumed", value: "\(todayCalories)", unit: "kcal",
                     icon: "fork.knife.circle.fill", color: .green)
            statCard(title: "Remaining", value: "\(remaining)", unit: "kcal",
                     icon: "minus.circle.fill", color: remaining > 0 ? .blue : .orange)
            statCard(title: "Burned", value: "\(todayBurned)", unit: "kcal",
                     icon: "flame.fill", color: .orange)
            statCard(title: "Net", value: "\(todayCalories - todayBurned)", unit: "kcal",
                     icon: "chart.bar.fill", color: .purple)
        }
    }

    private func statCard(title: String, value: String, unit: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon).foregroundStyle(color).font(.title2)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption).foregroundStyle(.secondary)
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(value).font(.title2.bold())
                    Text(unit).font(.caption).foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var weightCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Current Weight", systemImage: "scalemass.fill").font(.headline)
            if let w = currentWeight {
                let weightUnit = profile?.weightUnit ?? "kg"
                let (display, unit): (Double, String) = {
                    switch weightUnit {
                    case "lbs":   return (w * 2.20462, "lbs")
                    case "stone": return (w * 0.157473, "st")
                    default:      return (w, "kg")
                    }
                }()
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", display))
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.green)
                    Text(unit).font(.title3).foregroundStyle(.secondary)
                }
                if let goal = profile?.goalWeightKg {
                    let diff = w - goal
                    Text(diff > 0 ? String(format: "%.1f kg to goal", diff) : "Goal reached!")
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("No weight logged yet — go to Progress to log")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
