import SwiftUI

struct PlanRowView: View {
    let plan: TradePlan

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(plan.symbol)
                    .font(.headline)
                Spacer()
                Text(plan.status.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text("\(plan.direction.rawValue) 入场: \(plan.entryPrice, specifier: \"%.2f\")")
                .font(.subheadline)
        }
    }
}

struct PlanRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlanRowView(plan: TradePlan(symbol: "AAPL", direction: .long, entryPrice: 100, stopLoss: 90, takeProfit: 120, notes: ""))
    }
}
