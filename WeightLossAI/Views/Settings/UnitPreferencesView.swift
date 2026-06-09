import SwiftUI
import SwiftData

struct UnitPreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var profile: UserProfile

    var body: some View {
        NavigationStack {
            List {
                unitSection(
                    title: "Weight",
                    options: [("Pounds", "lbs"), ("Kilograms", "kg"), ("Stone", "stone")],
                    selection: $profile.weightUnit
                )
                unitSection(
                    title: "Height",
                    options: [("Feet / Inches", "ft"), ("Centimeters", "cm")],
                    selection: $profile.heightUnit
                )
                unitSection(
                    title: "Distance",
                    options: [("Miles", "miles"), ("Kilometers", "km")],
                    selection: $profile.distanceUnit
                )
                unitSection(
                    title: "Energy",
                    options: [("Calories", "cal"), ("Kilojoules", "kj")],
                    selection: $profile.energyUnit
                )
                unitSection(
                    title: "Water",
                    options: [("Cups", "cups"), ("Milliliters", "ml"), ("Fluid Ounces", "floz")],
                    selection: $profile.waterUnit
                )
            }
            .navigationTitle("Unit Preferences")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "checkmark")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }

    private func unitSection(
        title: String,
        options: [(label: String, value: String)],
        selection: Binding<String>
    ) -> some View {
        Section(title) {
            ForEach(options, id: \.value) { option in
                Button {
                    selection.wrappedValue = option.value
                } label: {
                    HStack {
                        Text(option.label)
                            .foregroundStyle(selection.wrappedValue == option.value ? Color.accentColor : .primary)
                        Spacer()
                        if selection.wrappedValue == option.value {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.accentColor)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
        }
    }
}
