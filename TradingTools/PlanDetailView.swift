import SwiftUI

struct PlanDetailView: View {
    @Binding var plan: TradePlan

    var body: some View {
        Form {
            Section(header: Text("基本信息")) {
                TextField("品种", text: $plan.symbol)
                Picker("方向", selection: $plan.direction) {
                    ForEach(TradeDirection.allCases) { dir in
                        Text(dir.rawValue).tag(dir)
                    }
                }
                TextField("入场价", value: $plan.entryPrice, format: .number)
                TextField("止损价", value: $plan.stopLoss, format: .number)
                TextField("止盈价", value: $plan.takeProfit, format: .number)
            }
            Section(header: Text("备注")) {
                TextField("备注", text: $plan.notes, axis: .vertical)
            }
            Section(header: Text("状态")) {
                Picker("状态", selection: $plan.status) {
                    ForEach(TradeStatus.allCases) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
            }
        }
        .navigationTitle(plan.symbol)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlanDetailView(plan: .constant(TradePlan(symbol: "TSLA", direction: .long, entryPrice: 100, stopLoss: 90, takeProfit: 120, notes: "")))
    }
}
