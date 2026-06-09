import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var step = 0
    @State private var name = ""
    @State private var goalWeight = ""
    @State private var currentWeight = ""
    @State private var dailyCalories = "1800"
    @State private var weightUnit = "kg"
    @State private var gender = "Not specified"

    private let totalSteps = 5

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background gradient shifts per step
            LinearGradient(
                colors: gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: step)

            VStack(spacing: 0) {
                // Progress dots
                if step > 0 {
                    progressDots
                        .padding(.top, 60)
                        .transition(.opacity)
                }

                Spacer()

                // Step content
                Group {
                    switch step {
                    case 0: welcomeStep
                    case 1: nameStep
                    case 2: genderStep
                    case 3: weightStep
                    case 4: calorieStep
                    default: EmptyView()
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                .id(step)

                Spacer()

                // Bottom buttons
                bottomBar
                    .padding(.bottom, 48)
                    .padding(.horizontal, 28)
            }
        }
    }

    // MARK: - Progress dots

    private var progressDots: some View {
        HStack(spacing: 8) {
            ForEach(1..<totalSteps, id: \.self) { i in
                Capsule()
                    .fill(i <= step ? Color.white : Color.white.opacity(0.3))
                    .frame(width: i == step ? 24 : 8, height: 8)
                    .animation(.spring(duration: 0.4), value: step)
            }
        }
    }

    // MARK: - Step 0: Welcome

    private var welcomeStep: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 100))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.2), radius: 12)
                .scaleEffect(step == 0 ? 1 : 0.8)
                .animation(.spring(duration: 0.6), value: step)

            VStack(spacing: 12) {
                Text("Welcome to Bloom")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.white)
                Text("Your wellness journey starts here.\nNourish your body, move with joy,\nand feel your absolute best.")
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            HStack(spacing: 32) {
                featurePill(icon: "fork.knife", label: "Nutrition")
                featurePill(icon: "figure.yoga", label: "Movement")
                featurePill(icon: "sparkles", label: "Mira AI")
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 32)
    }

    private func featurePill(icon: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
            Text(label)
                .font(.caption.bold())
                .foregroundStyle(.white.opacity(0.9))
        }
        .frame(width: 80, height: 70)
        .background(.white.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Step 1: Name

    private var nameStep: some View {
        VStack(spacing: 28) {
            stepHeader(
                icon: "person.circle.fill",
                title: "What should we call you?",
                subtitle: "We'll make everything feel just right for you."
            )
            VStack(alignment: .leading, spacing: 8) {
                Text("Your name").font(.subheadline).foregroundStyle(.white.opacity(0.8))
                TextField("", text: $name)
                    .placeholder(when: name.isEmpty) {
                        Text("e.g. Alex").foregroundStyle(.white.opacity(0.4))
                    }
                    .font(.title3)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.white.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .autocorrectionDisabled()
            }
            .padding(.horizontal, 32)
        }
    }

    // MARK: - Step 2: Gender

    private var genderStep: some View {
        VStack(spacing: 28) {
            stepHeader(
                icon: "person.2.circle.fill",
                title: "Tell us about you",
                subtitle: "Helps us tailor your nutrition and wellness plan."
            )
            VStack(spacing: 12) {
                ForEach(["Male", "Female", "Non-binary", "Not specified"], id: \.self) { option in
                    Button {
                        withAnimation(.spring(duration: 0.3)) { gender = option }
                    } label: {
                        HStack {
                            Text(option)
                                .font(.body.bold())
                                .foregroundStyle(gender == option ? .black : .white)
                            Spacer()
                            if gender == option {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.black)
                            }
                        }
                        .padding()
                        .background(gender == option ? Color.white : Color.white.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
            }
            .padding(.horizontal, 32)
        }
    }

    // MARK: - Step 3: Weight & Goal

    private var weightStep: some View {
        VStack(spacing: 28) {
            stepHeader(
                icon: "scalemass.fill",
                title: "Your body, your journey",
                subtitle: "Every body is different — let's start from where you are."
            )
            VStack(spacing: 16) {
                Picker("Unit", selection: $weightUnit) {
                    Text("kg").tag("kg")
                    Text("lbs").tag("lbs")
                    Text("stone").tag("stone")
                }
                .pickerStyle(.segmented)
                .colorMultiply(.white)

                inputField(
                    label: "Current weight (\(weightUnit))",
                    placeholder: weightUnit == "kg" ? "e.g. 85" : "e.g. 187",
                    text: $currentWeight
                )
                inputField(
                    label: "Goal weight (\(weightUnit))",
                    placeholder: weightUnit == "kg" ? "e.g. 70" : "e.g. 154",
                    text: $goalWeight
                )
            }
            .padding(.horizontal, 32)
        }
    }

    // MARK: - Step 4: Calorie Target

    private var calorieStep: some View {
        VStack(spacing: 28) {
            stepHeader(
                icon: "flame.circle.fill",
                title: "Nourish your body",
                subtitle: "A sustainable goal keeps you energised and feeling great."
            )
            VStack(spacing: 20) {
                inputField(label: "Daily target (kcal)", placeholder: "e.g. 1800", text: $dailyCalories, keyboard: .numberPad)

                // Quick-select buttons
                HStack(spacing: 10) {
                    ForEach(["1200", "1500", "1800", "2000"], id: \.self) { val in
                        Button {
                            withAnimation { dailyCalories = val }
                        } label: {
                            Text(val)
                                .font(.subheadline.bold())
                                .foregroundStyle(dailyCalories == val ? .black : .white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(dailyCalories == val ? Color.white : Color.white.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
            .padding(.horizontal, 32)
        }
    }

    // MARK: - Bottom bar

    private var bottomBar: some View {
        Group {
            if step == 0 {
                Button {
                    withAnimation(.spring(duration: 0.4)) { step += 1 }
                } label: {
                    Text("Get Started")
                        .font(.body.bold())
                        .foregroundStyle(nextButtonTextColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
            } else {
                HStack {
                    Button {
                        withAnimation(.spring(duration: 0.4)) { step -= 1 }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.body.bold())
                        .foregroundStyle(.white.opacity(0.8))
                    }

                    Spacer()

                    Button {
                        if step < totalSteps - 1 {
                            withAnimation(.spring(duration: 0.4)) { step += 1 }
                        } else {
                            saveProfile()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text(step == totalSteps - 1 ? "Let's go!" : "Continue")
                            if step < totalSteps - 1 {
                                Image(systemName: "chevron.right")
                            }
                        }
                        .font(.body.bold())
                        .foregroundStyle(nextButtonTextColor)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .clipShape(Capsule())
                    }
                    .disabled(!canAdvance)
                    .opacity(canAdvance ? 1 : 0.5)
                }
            }
        }
    }

    // MARK: - Helpers

    private func stepHeader(icon: String, title: String, subtitle: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(.white)
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
    }

    private func inputField(label: String, placeholder: String, text: Binding<String>, keyboard: UIKeyboardType = .decimalPad) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.subheadline).foregroundStyle(.white.opacity(0.8))
            TextField("", text: text)
                .placeholder(when: text.wrappedValue.isEmpty) {
                    Text(placeholder).foregroundStyle(.white.opacity(0.4))
                }
                .font(.title3)
                .foregroundStyle(.white)
                .keyboardType(keyboard)
                .padding()
                .background(.white.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    private var gradientColors: [Color] {
        switch step {
        case 0: return [Color(hex: "6A0572"), Color(hex: "C4607A"), Color(hex: "E8A0BF")]
        case 1: return [Color(hex: "C4607A"), Color(hex: "E07B8A")]
        case 2: return [Color(hex: "9B59B6"), Color(hex: "C4607A")]
        case 3: return [Color(hex: "E07B8A"), Color(hex: "FFAFBD")]
        default: return [Color(hex: "C4607A"), Color(hex: "9B59B6")]
        }
    }

    private var nextButtonTextColor: Color {
        switch step {
        case 0: return Color(hex: "6A0572")
        case 1: return Color(hex: "C4607A")
        case 2: return Color(hex: "9B59B6")
        case 3: return Color(hex: "E07B8A")
        default: return Color(hex: "C4607A")
        }
    }

    private var canAdvance: Bool {
        switch step {
        case 0: return true
        case 1: return !name.trimmingCharacters(in: .whitespaces).isEmpty
        case 2: return true
        case 3: return !currentWeight.isEmpty && !goalWeight.isEmpty
        case 4: return !dailyCalories.isEmpty
        default: return true
        }
    }

    private func toKg(_ value: String) -> Double {
        let v = Double(value) ?? 0
        switch weightUnit {
        case "lbs":   return v / 2.20462
        case "stone": return v / 0.157473
        default:      return v
        }
    }

    private func saveProfile() {
        let profile = UserProfile(
            name: name,
            goalWeightKg: toKg(goalWeight),
            dailyCalorieTarget: Int(dailyCalories) ?? 1800,
            weightUnit: weightUnit
        )
        modelContext.insert(profile)
        if !currentWeight.isEmpty {
            modelContext.insert(WeightEntry(weightKg: toKg(currentWeight)))
        }
    }
}

// MARK: - Extensions

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

extension View {
    func placeholder<Content: View>(when condition: Bool, @ViewBuilder content: () -> Content) -> some View {
        ZStack(alignment: .leading) {
            if condition { content() }
            self
        }
    }
}
