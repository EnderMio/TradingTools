import SwiftUI

struct PlanRowView: View {
    let plan: TradePlan

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(plan.symbol)
                    .font(.headline)
                Spacer()
                Text(plan.status.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            HStack(spacing: 12) {
                Text(plan.direction.rawValue)
                Text("入 \(plan.entryPrice, specifier: \"%.2f\")")
                Text("止损 \(plan.stopLoss, specifier: \"%.2f\")")
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct PlanRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlanRowView(plan: TradePlan(symbol: "AAPL", direction: .long, entryPrice: 100, stopLoss: 90, notes: ""))
    }
}
