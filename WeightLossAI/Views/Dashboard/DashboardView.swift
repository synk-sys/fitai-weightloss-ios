import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \WeightEntry.date, order: .reverse) private var weightEntries: [WeightEntry]
    @Query(sort: \FoodEntry.date, order: .reverse) private var foodEntries: [FoodEntry]
    @Query(sort: \WorkoutEntry.date, order: .reverse) private var workoutEntries: [WorkoutEntry]
    @Query private var profiles: [UserProfile]

    private var profile: UserProfile? { profiles.first }
    private var todayCalories: Int {
        foodEntries.filter { Calendar.current.isDateInToday($0.date) }
            .reduce(0) { $0 + $1.calories }
    }
    private var todayBurned: Int {
        workoutEntries.filter { Calendar.current.isDateInToday($0.date) }
            .reduce(0) { $0 + $1.caloriesBurned }
    }
    private var currentWeight: Double? { weightEntries.first?.weightKg }
    private var netCalories: Int { todayCalories - todayBurned }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    greetingCard
                    calorieRing
                    statsRow
                    weightCard
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
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
                .font(.system(size: 44))
                .foregroundStyle(.green)
        }
        .padding()
        .background(.green.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var calorieRing: some View {
        let target = Double(profile?.dailyCalorieTarget ?? 1800)
        let consumed = Double(todayCalories)
        let progress = min(consumed / target, 1.0)
        let remaining = max(Int(target) - todayCalories, 0)

        return VStack(spacing: 12) {
            Text("Today's Calories").font(.headline)
            ZStack {
                Circle()
                    .stroke(Color.green.opacity(0.2), lineWidth: 18)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(progress < 1 ? Color.green : Color.orange,
                            style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress)
                VStack(spacing: 2) {
                    Text("\(todayCalories)")
                        .font(.system(size: 32, weight: .bold))
                    Text("of \(profile?.dailyCalorieTarget ?? 1800) kcal")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 160, height: 160)

            Text(remaining > 0 ? "\(remaining) kcal remaining" : "Daily target reached!")
                .font(.subheadline)
                .foregroundStyle(remaining > 0 ? .secondary : .orange)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8)
    }

    private var statsRow: some View {
        HStack(spacing: 12) {
            statCard(title: "Burned", value: "\(todayBurned)", unit: "kcal", icon: "flame.fill", color: .orange)
            statCard(title: "Net", value: "\(netCalories)", unit: "kcal", icon: "minus.circle.fill", color: .blue)
        }
    }

    private func statCard(title: String, value: String, unit: String, icon: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon).foregroundStyle(color).font(.title2)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption).foregroundStyle(.secondary)
                Text(value).font(.title2.bold()) + Text(" \(unit)").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.06), radius: 6)
    }

    private var weightCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Current Weight", systemImage: "scalemass").font(.headline)
            if let w = currentWeight {
                let display = profile?.useMetric == false ? w * 2.20462 : w
                let unit = profile?.useMetric == false ? "lbs" : "kg"
                Text(String(format: "%.1f %@", display, unit))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.green)
                if let goal = profile?.goalWeightKg {
                    let diff = w - goal
                    Text(diff > 0 ? String(format: "%.1f kg to goal", diff) : "Goal reached! 🎉")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("No weight logged yet")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8)
    }
}
