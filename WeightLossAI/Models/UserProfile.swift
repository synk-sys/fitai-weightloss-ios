import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var goalWeightKg: Double
    var dailyCalorieTarget: Int
    var useMetric: Bool

    init(name: String = "", goalWeightKg: Double = 70.0,
         dailyCalorieTarget: Int = 1800, useMetric: Bool = true) {
        self.id = UUID()
        self.name = name
        self.goalWeightKg = goalWeightKg
        self.dailyCalorieTarget = dailyCalorieTarget
        self.useMetric = useMetric
    }
}
