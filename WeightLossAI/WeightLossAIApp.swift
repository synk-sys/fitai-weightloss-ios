import SwiftUI
import SwiftData

@main
struct WeightLossAIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [WeightEntry.self, FoodEntry.self, WorkoutEntry.self, UserProfile.self])
    }
}
