import SwiftUI

struct AIChatView: View {
    @StateObject private var ai = AIManager.shared
    @State private var messages: [ChatMessage] = [
        ChatMessage(role: .assistant, content: "Hi! I'm your AI weight-loss coach. Ask me anything about nutrition, exercise, or staying motivated. How can I help you today?")
    ]
    @State private var inputText = ""
    @State private var isLoading = false
    @FocusState private var inputFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                messageList
                inputBar
            }
            .navigationTitle("AI Coach")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Clear") {
                        messages = [messages[0]]
                    }
                }
            }
        }
    }

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        messageBubble(message)
                            .id(message.id)
                    }
                    if isLoading {
                        typingIndicator
                    }
                }
                .padding()
            }
            .onChange(of: messages.count) {
                withAnimation {
                    proxy.scrollTo(messages.last?.id, anchor: .bottom)
                }
            }
            .onChange(of: isLoading) {
                withAnimation {
                    proxy.scrollTo(messages.last?.id, anchor: .bottom)
                }
            }
        }
    }

    private func messageBubble(_ message: ChatMessage) -> some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.role == .assistant {
                Image(systemName: "brain.head.profile")
                    .font(.title3)
                    .foregroundStyle(.green)
                    .frame(width: 32, height: 32)
                    .background(.green.opacity(0.15))
                    .clipShape(Circle())
            }

            if message.role == .user { Spacer() }

            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(message.role == .user ? Color.green : Color(.systemGray6))
                    .foregroundStyle(message.role == .user ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            if message.role == .assistant { Spacer() }
        }
    }

    private var typingIndicator: some View {
        HStack(spacing: 8) {
            Image(systemName: "brain.head.profile")
                .font(.title3)
                .foregroundStyle(.green)
                .frame(width: 32, height: 32)
                .background(.green.opacity(0.15))
                .clipShape(Circle())
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 8, height: 8)
                        .scaleEffect(isLoading ? 1 : 0.5)
                        .animation(.easeInOut(duration: 0.6).repeatForever().delay(Double(i) * 0.2),
                                   value: isLoading)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            Spacer()
        }
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Ask your coach...", text: $inputText, axis: .vertical)
                .lineLimit(1...4)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .focused($inputFocused)

            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(inputText.isEmpty || isLoading ? .secondary : .green)
            }
            .disabled(inputText.isEmpty || isLoading)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.background)
        .overlay(alignment: .top) {
            Divider()
        }
    }

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputText = ""
        messages.append(ChatMessage(role: .user, content: text))
        isLoading = true

        Task {
            do {
                let reply = try await ai.sendMessage(text, history: messages)
                messages.append(ChatMessage(role: .assistant, content: reply))
            } catch {
                messages.append(ChatMessage(role: .assistant,
                    content: "Sorry, I couldn't connect. Please try again."))
            }
            isLoading = false
        }
    }
}
