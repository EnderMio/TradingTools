import SwiftUI

struct PlanRowView: View {
    let plan: TradePlan

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(plan.symbol)
                    .font(.headline)
                Spacer()
                Text(plan.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            HStack {
                Text(plan.actionTime, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
            }
            HStack {
                Spacer()
                Text(plan.status.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            HStack(spacing: 12) {
                Text(plan.direction.rawValue)
                    .foregroundColor(plan.direction == .long ? .green : .red)
                Text("入 \(plan.entryPrice, specifier: \"%.2f\")")
                Text("止损 \(plan.stopLoss, specifier: \"%.2f\")")
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
}

struct PlanRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlanRowView(plan: TradePlan(symbol: "AAPL", direction: .long, entryPrice: 100, stopLoss: 90, notes: ""))
    }
}
