import SwiftUI
import SwiftData

struct AddWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var type = "Running"
    @State private var duration = ""
    @State private var calories = ""
    @State private var note = ""
    @State private var date = Date.now

    var body: some View {
        NavigationStack {
            Form {
                Section("Workout") {
                    Picker("Type", selection: $type) {
                        ForEach(WorkoutEntry.workoutTypes, id: \.self) { Text($0) }
                    }
                    DatePicker("Date & Time", selection: $date)
                }
                Section("Details") {
                    HStack {
                        Text("Duration (minutes)")
                        Spacer()
                        TextField("0", text: $duration)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                    }
                    HStack {
                        Text("Calories burned")
                        Spacer()
                        TextField("0", text: $calories)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                    }
                }
                Section("Notes") {
                    TextField("Optional notes...", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Log Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(duration.isEmpty)
                }
            }
        }
    }

    private func save() {
        let entry = WorkoutEntry(
            date: date,
            type: type,
            durationMin: Int(duration) ?? 0,
            caloriesBurned: Int(calories) ?? 0,
            note: note
        )
        modelContext.insert(entry)
        dismiss()
    }
}
