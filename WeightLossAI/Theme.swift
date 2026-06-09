import SwiftUI

enum Theme {
    static let primary   = Color(hex: "C4607A")   // deep rose
    static let secondary = Color(hex: "E8A0BF")   // blush pink
    static let accent    = Color(hex: "9B59B6")   // soft lavender-purple
    static let soft      = Color(hex: "F7CAD0")   // pale blush
    static let warm      = Color(hex: "E07B8A")   // warm rose

    // Gradient pairs used across the app
    static let gradientMain   = [Color(hex: "C4607A"), Color(hex: "9B59B6")]
    static let gradientSoft   = [Color(hex: "F7CAD0"), Color(hex: "E8A0BF")]
    static let gradientDark   = [Color(hex: "6A0572"), Color(hex: "C4607A")]
    static let gradientPeach  = [Color(hex: "FFAFBD"), Color(hex: "FFC3A0")]
    static let gradientMauve  = [Color(hex: "8E44AD"), Color(hex: "E8A0BF")]
}
