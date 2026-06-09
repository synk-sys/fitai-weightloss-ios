import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var profiles: [UserProfile]
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0

    var body: some View {
        Group {
            if profiles.isEmpty {
                OnboardingView()
            } else {
                mainTabView
            }
        }
        .onAppear {
            if profiles.isEmpty {
                modelContext.insert(UserProfile())
            }
        }
    }

    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            SummaryView()
                .tabItem { Label("Dashboard", systemImage: "house.fill") }
                .tag(0)

            DashboardView()
                .tabItem { Label("Food", systemImage: "fork.knife") }
                .tag(1)

            WorkoutLogView()
                .tabItem { Label("Workouts", systemImage: "flame.fill") }
                .tag(2)

            ProgressView()
                .tabItem { Label("Progress", systemImage: "chart.line.uptrend.xyaxis") }
                .tag(3)

            AIChatView()
                .tabItem { Label("AI Assistant", systemImage: "brain.head.profile") }
                .tag(4)
        }
        .tint(Theme.primary)
    }
}
