import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var goalWeightKg: Double
    var dailyCalorieTarget: Int

    // Unit preferences
    var weightUnit: String      // "kg", "lbs", "stone"
    var heightUnit: String      // "cm", "ft"
    var distanceUnit: String    // "km", "miles"
    var energyUnit: String      // "cal", "kj"
    var waterUnit: String       // "ml", "cups", "floz"

    init(name: String = "", goalWeightKg: Double = 70.0,
         dailyCalorieTarget: Int = 1800,
         weightUnit: String = "kg", heightUnit: String = "cm",
         distanceUnit: String = "km", energyUnit: String = "cal",
         waterUnit: String = "ml") {
        self.id = UUID()
        self.name = name
        self.goalWeightKg = goalWeightKg
        self.dailyCalorieTarget = dailyCalorieTarget
        self.weightUnit = weightUnit
        self.heightUnit = heightUnit
        self.distanceUnit = distanceUnit
        self.energyUnit = energyUnit
        self.waterUnit = waterUnit
    }

    // Convenience
    var useMetric: Bool { weightUnit == "kg" }
}
