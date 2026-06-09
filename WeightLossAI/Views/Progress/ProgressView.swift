import SwiftUI
import SwiftData
import Charts

struct ProgressView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WeightEntry.date) private var weightEntries: [WeightEntry]
    @Query private var profiles: [UserProfile]
    @State private var showingAddWeight = false
    @State private var newWeight = ""

    private var profile: UserProfile? { profiles.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    weightChartCard
                    logWeightCard
                    weightHistoryList
                }
                .padding()
            }
            .navigationTitle("Progress")
        }
    }

    private var weightChartCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weight Trend").font(.headline)
            if weightEntries.isEmpty {
                Text("Log your weight to see progress here")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                Chart {
                    ForEach(weightEntries) { entry in
                        LineMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weightKg)
                        )
                        .foregroundStyle(.green)
                        PointMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weightKg)
                        )
                        .foregroundStyle(.green)
                    }
                    if let goal = profile?.goalWeightKg {
                        RuleMark(y: .value("Goal", goal))
                            .lineStyle(StrokeStyle(dash: [5]))
                            .foregroundStyle(.orange)
                            .annotation(position: .trailing) {
                                Text("Goal").font(.caption).foregroundStyle(.orange)
                            }
                    }
                }
                .frame(height: 200)
                .chartYAxis { AxisMarks(position: .leading) }
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8)
    }

    private var logWeightCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Log Today's Weight").font(.headline)
            HStack {
                TextField("Weight (kg)", text: $newWeight)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                Button("Log") {
                    if let kg = Double(newWeight) {
                        modelContext.insert(WeightEntry(weightKg: kg))
                        newWeight = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(newWeight.isEmpty)
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8)
    }

    private var weightHistoryList: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("History").font(.headline)
            if weightEntries.isEmpty {
                Text("No entries yet").foregroundStyle(.secondary)
            } else {
                ForEach(weightEntries.reversed()) { entry in
                    HStack {
                        Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        Spacer()
                        Text(String(format: "%.1f kg", entry.weightKg))
                            .fontWeight(.semibold)
                    }
                    Divider()
                }
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8)
    }
}
