import SwiftUI
import SwiftData

struct WorkoutLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutEntry.date, order: .reverse) private var entries: [WorkoutEntry]
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List {
                if entries.isEmpty {
                    ContentUnavailableView("No workouts yet",
                        systemImage: "flame",
                        description: Text("Tap + to log your first workout"))
                } else {
                    ForEach(entries) { entry in
                        workoutRow(entry)
                    }
                    .onDelete { offsets in
                        for i in offsets { modelContext.delete(entries[i]) }
                    }
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showingAdd = true } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddWorkoutView()
            }
        }
    }

    private func workoutRow(_ entry: WorkoutEntry) -> some View {
        HStack(spacing: 14) {
            Image(systemName: entry.icon)
                .font(.title2)
                .foregroundStyle(.orange)
                .frame(width: 36)
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.type).fontWeight(.semibold)
                Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(entry.durationMin) min")
                    .font(.subheadline.bold())
                if entry.caloriesBurned > 0 {
                    Text("\(entry.caloriesBurned) kcal")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
