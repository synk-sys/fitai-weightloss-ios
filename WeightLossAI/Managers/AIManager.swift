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
        // Simulate network delay during development
        try await Task.sleep(for: .seconds(1))

        // --- Replace this block with a real API call ---
        return generatePlaceholderResponse(for: userMessage)
        // ------------------------------------------------
    }

    // Simple rule-based placeholder until the API is wired up
    private func generatePlaceholderResponse(for message: String) -> String {
        let lower = message.lowercased()
        if lower.contains("calorie") || lower.contains("food") || lower.contains("eat") {
            return "Great question! To manage calories effectively, focus on whole foods like vegetables, lean proteins, and complex carbs. Would you like specific meal ideas?"
        } else if lower.contains("workout") || lower.contains("exercise") {
            return "Exercise is key to sustainable weight loss. I recommend a mix of cardio and strength training. What's your current fitness level?"
        } else if lower.contains("weight") || lower.contains("progress") {
            return "Consistent progress tracking is one of the best predictors of success. Aim for 0.5–1 kg loss per week for sustainable results."
        } else if lower.contains("motivat") {
            return "You're doing great by showing up! Remember — every small step counts. What's one thing you can do today to move toward your goal?"
        } else {
            return "I'm your personal AI weight-loss coach. I can help with meal planning, workout advice, calorie guidance, and keeping you motivated. What would you like to work on?"
        }
    }
}
