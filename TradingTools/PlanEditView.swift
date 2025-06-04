import SwiftUI

struct PlanEditView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: TradePlanStore
    @State private var symbol: String = ""
    @State private var direction: TradeDirection = .long
    @State private var entry: String = ""
    @State private var stopLoss: String = ""
    @State private var takeProfit: String = ""
    @State private var actionTime: Date = Calendar.current.date(bySettingHour: 9, minute: 30, second: 0, of: .now) ?? .now
    @State private var notes: String = ""
    @State private var date: Date = Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("品种", text: $symbol)
                    Picker("方向", selection: $direction) {
                        ForEach(TradeDirection.allCases) { dir in
                            Text(dir.rawValue).tag(dir)
                        }
                    }
                    DatePicker("日期", selection: $date, displayedComponents: .date)
                    DatePicker("操作时间", selection: $actionTime, displayedComponents: .hourAndMinute)
                    TextField("入场价", text: $entry)
                        .keyboardType(.decimalPad)
                    TextField("止损价", text: $stopLoss)
                        .keyboardType(.decimalPad)
                    TextField("止盈条件", text: $takeProfit)
                }
                Section(header: Text("备注")) {
                    TextField("备注", text: $notes, axis: .vertical)
                }
            }
            .navigationTitle("新计划")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { save() }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
            }
        }
    }

    private func save() {
        guard let entryP = Double(entry), let sl = Double(stopLoss) else { return }
        let plan = TradePlan(symbol: symbol,
                             direction: direction,
                             date: date,
                             actionTime: actionTime,
                             takeProfitCondition: takeProfit,
                             entryPrice: entryP,
                             stopLoss: sl,
                             notes: notes)
        store.add(plan)
        dismiss()
    }
}

struct PlanEditView_Previews: PreviewProvider {
    static var previews: some View {
        PlanEditView(store: TradePlanStore())
    }
}
