import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var name = ""
    @State private var goalWeight = ""
    @State private var dailyCalories = "1800"
    @State private var useMetric = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Image(systemName: "figure.walk.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.green)
                        Text("Welcome to FitAI")
                            .font(.largeTitle.bold())
                        Text("Your personal weight-loss companion")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)

                    VStack(alignment: .leading, spacing: 16) {
                        label("Your Name")
                        TextField("Enter your name", text: $name)
                            .textFieldStyle(.roundedBorder)

                        Picker("Unit System", selection: $useMetric) {
                            Text("Metric (kg)").tag(true)
                            Text("Imperial (lbs)").tag(false)
                        }
                        .pickerStyle(.segmented)

                        label("Goal Weight (\(useMetric ? "kg" : "lbs"))")
                        TextField(useMetric ? "e.g. 70" : "e.g. 154", text: $goalWeight)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)

                        label("Daily Calorie Target")
                        TextField("e.g. 1800", text: $dailyCalories)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                    }
                    .padding(.horizontal)

                    Button(action: saveProfile) {
                        Text("Get Started")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.green)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal)
                    .disabled(name.isEmpty || goalWeight.isEmpty)
                }
            }
        }
    }

    private func label(_ text: String) -> some View {
        Text(text).font(.subheadline).fontWeight(.medium)
    }

    private func saveProfile() {
        var goalKg = Double(goalWeight) ?? 70
        if !useMetric { goalKg /= 2.20462 }
        let profile = UserProfile(
            name: name,
            goalWeightKg: goalKg,
            dailyCalorieTarget: Int(dailyCalories) ?? 1800,
            useMetric: useMetric
        )
        modelContext.insert(profile)
    }
}
