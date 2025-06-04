import SwiftUI

struct PlanRowView: View {
    let plan: Plan
    let latest: Record?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(plan.symbol)
                    .font(.headline)
                Spacer()
                if let d = latest?.date { Text(d, style: .date).font(.caption).foregroundColor(.secondary) }
            }
            if let time = latest?.operationTime {
                HStack {
                    Text(time, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            HStack {
                Spacer()
                Text(latest?.actionToday ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            HStack(spacing: 12) {
                if let e = latest?.entryPrice, e != 0 {
                    Text("入 \(String(format: "%.2f", e))")
                }
                if let sl = latest?.stopLoss, sl != 0 {
                    Text("止损 \(String(format: "%.2f", sl))")
                }
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
        )
    }
}

struct PlanRowView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let store = PlanStore(context: context)
        return PlanRowView(plan: store.plans.first ?? Plan(context: context), latest: nil)
    }
}
