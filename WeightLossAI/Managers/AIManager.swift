import Foundation

// Placeholder AI manager — swap the body of sendMessage() to call
// your chosen LLM API (Claude, OpenAI, etc.)
@MainActor
class AIManager: ObservableObject {
    static let shared = AIManager()

    // MARK: - API Configuration (fill in when ready)
    // private let apiKey = "YOUR_API_KEY"
    // private let endpoint = URL(string: "https://api.anthropic.com/v1/messages")!

    func sendMessage(_ userMessage: String, history: [ChatMessage]) async throws -> String {
        try await Task.sleep(for: .seconds(1))
        return generatePlaceholderResponse(for: userMessage)
    }

    private func generatePlaceholderResponse(for message: String) -> String {
        let lower = message.lowercased()
        if lower.contains("calorie") || lower.contains("food") || lower.contains("eat") || lower.contains("meal") {
            return "Nourishing your body is an act of self-love 💕 Focus on whole, colourful foods — think leafy greens, lean proteins, healthy fats, and complex carbs. Would you like some meal ideas tailored to your goals?"
        } else if lower.contains("workout") || lower.contains("exercise") || lower.contains("move") {
            return "Movement should feel joyful, not punishing! Whether it's a yoga flow, a brisk walk, or a dance session — anything that gets your heart pumping counts. What kind of movement do you enjoy most?"
        } else if lower.contains("weight") || lower.contains("progress") || lower.contains("plateau") {
            return "Progress isn't always linear, and that's completely normal. Your body is doing amazing things even when the scale doesn't move. Focus on how you feel — energy, sleep, strength — those are real wins too 🌸"
        } else if lower.contains("motivat") || lower.contains("tired") || lower.contains("give up") || lower.contains("hard") {
            return "Hey, you showed up today and that already matters so much 💪 Every small choice — the walk, the water, the salad — adds up. You are worth this effort. What's one tiny thing you can do right now for yourself?"
        } else if lower.contains("period") || lower.contains("cycle") || lower.contains("hormone") || lower.contains("bloat") {
            return "Hormonal fluctuations are so real and can affect energy, cravings, and even the scale. Be extra gentle with yourself during your cycle — your needs change throughout the month and that's completely natural 🌙"
        } else if lower.contains("stress") || lower.contains("anxious") || lower.contains("overwhelm") {
            return "Stress can genuinely affect weight and wellbeing — it's not just in your head. Prioritising rest, deep breathing, and small joyful moments is just as important as what you eat. You're doing the best you can 🤍"
        } else if lower.contains("sleep") {
            return "Sleep is one of the most underrated tools for weight loss and overall health. Poor sleep raises hunger hormones and makes cravings harder to resist. Aim for 7–9 hours and treat bedtime like a sacred ritual 🌙"
        } else {
            return "Hi beautiful! I'm Mira, your personal wellness companion. I'm here to support your nutrition, movement, mindset, and everything in between — with zero judgment. What's on your mind today? 💕"
        }
    }
}
