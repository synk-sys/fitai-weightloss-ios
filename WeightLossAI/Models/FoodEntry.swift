import Foundation
import SwiftData

@Model
final class FoodEntry {
    var id: UUID
    var date: Date
    var name: String
    var calories: Int
    var proteinG: Double
    var carbsG: Double
    var fatG: Double
    var mealType: String  // "Breakfast", "Lunch", "Dinner", "Snack"

    init(date: Date = .now, name: String, calories: Int,
         proteinG: Double = 0, carbsG: Double = 0, fatG: Double = 0,
         mealType: String = "Snack") {
        self.id = UUID()
        self.date = date
        self.name = name
        self.calories = calories
        self.proteinG = proteinG
        self.carbsG = carbsG
        self.fatG = fatG
        self.mealType = mealType
    }
}
