import SwiftUI

struct PlanEditView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var store: PlanStore

    @State private var symbol: String = ""
    @State private var strategy: String = ""
    @State private var firstDate: Date = Date()
    @State private var actionTime: Date = Calendar.current.date(bySettingHour: 14, minute: 50, second: 0, of: .now) ?? .now
    @State private var entry: String = ""
    @State private var stopLoss: String = ""
    @State private var quantity: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("品种", text: $symbol)
                    TextField("策略", text: $strategy)
                    DatePicker("第一天日期", selection: $firstDate, displayedComponents: .date)
                    DatePicker("建仓操作时间", selection: $actionTime, displayedComponents: .hourAndMinute)
                    TextField("入场价", text: $entry).keyboardType(.decimalPad)
                    TextField("止损价", text: $stopLoss).keyboardType(.decimalPad)
                    TextField("买入仓位", text: $quantity).keyboardType(.numberPad)
                }
                Section(header: Text("备注")) {
                    TextField("备注", text: $notes, axis: .vertical)
                }
            }
            .navigationTitle("新建交易计划")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { savePlan() }.disabled(symbol.isEmpty || strategy.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
            }
        }
    }

    private func savePlan() {
        let entryP = Double(entry) ?? 0
        let sl = Double(stopLoss) ?? 0
        let qty = Int32(Double(quantity) ?? 0)
        store.addNewPlan(symbol: symbol, strategy: strategy, firstDate: firstDate, actionTime: actionTime, entryPrice: entryP, stopLoss: sl, buyQty: qty, notes: notes)
        dismiss()
    }
}

struct PlanEditView_Previews: PreviewProvider {
    static var previews: some View {
        PlanEditView(store: PlanStore(context: PersistenceController.shared.container.viewContext))
    }
}
