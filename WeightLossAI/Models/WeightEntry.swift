import Foundation
import SwiftData

@Model
final class WeightEntry {
    var id: UUID
    var date: Date
    var weightKg: Double
    var note: String

    init(date: Date = .now, weightKg: Double, note: String = "") {
        self.id = UUID()
        self.date = date
        self.weightKg = weightKg
        self.note = note
    }

    var weightLbs: Double { weightKg * 2.20462 }
}
