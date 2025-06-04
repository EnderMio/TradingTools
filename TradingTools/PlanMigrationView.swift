import SwiftUI

struct PlanMigrationView: View {
    @Binding var plan: TradePlan
    var onComplete: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("今日操作")) {
                    Picker("状态", selection: $plan.status) {
                        ForEach(TradeStatus.allCases) { st in
                            Text(st.rawValue).tag(st)
                        }
                    }
                    if plan.status == .open {
                        TextField("入场价", value: $plan.entryPrice, format: .number)
                        TextField("止损价", value: $plan.stopLoss, format: .number)
                    }
                }
                Section(header: Text("备注")) {
                    TextField("备注", text: $plan.notes)
                }
            }
            .navigationTitle("更新计划")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("下一步") { migrate() }
                }
            }
        }
    }

    private func migrate() {
        plan.date = Calendar.current.date(byAdding: .day, value: 1, to: plan.date) ?? plan.date
        onComplete()
    }
}

#Preview {
    PlanMigrationView(plan: .constant(TradePlan(symbol: "AAPL", direction: .long, entryPrice: 10, stopLoss: 9, notes: ""))) {}
}
