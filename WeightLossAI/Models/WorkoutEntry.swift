import Foundation
import SwiftData

@Model
final class WorkoutEntry {
    var id: UUID
    var date: Date
    var type: String       // "Running", "Cycling", "Strength", etc.
    var durationMin: Int
    var caloriesBurned: Int
    var note: String

    init(date: Date = .now, type: String, durationMin: Int,
         caloriesBurned: Int = 0, note: String = "") {
        self.id = UUID()
        self.date = date
        self.type = type
        self.durationMin = durationMin
        self.caloriesBurned = caloriesBurned
        self.note = note
    }
}

extension WorkoutEntry {
    static let workoutTypes = [
        "Running", "Walking", "Cycling", "Swimming",
        "Strength Training", "HIIT", "Yoga", "Pilates", "Other"
    ]

    var icon: String {
        switch type {
        case "Running": return "figure.run"
        case "Walking": return "figure.walk"
        case "Cycling": return "figure.outdoor.cycle"
        case "Swimming": return "figure.pool.swim"
        case "Strength Training": return "dumbbell"
        case "HIIT": return "bolt.heart"
        case "Yoga": return "figure.yoga"
        case "Pilates": return "figure.pilates"
        default: return "figure.mixed.cardio"
        }
    }
}
