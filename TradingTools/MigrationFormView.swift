import SwiftUI

struct MigrationFormView: View {
    let plan: Plan
    @ObservedObject var store: PlanStore
    let onComplete: () -> Void

    private var todayRecord: Record? {
        let recs = plan.records
        let today = Calendar.current.startOfDay(for: Date())
        return recs.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) })
    }

    @State private var actionToday: String = "无"
    @State private var entry: String = ""
    @State private var stopLoss: String = ""
    @State private var takeProfit: String = ""
    @State private var quantity: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("品种/策略")) {
                    Text(plan.symbol)
                    Text(plan.strategy)
                }
                Section(header: Text("今日操作")) {
                    Picker("状态", selection: $actionToday) {
                        ForEach(["无","建仓","持有","部分止盈","止损"], id: \ .self) { Text($0) }
                    }
                    if actionToday == "建仓" {
                        TextField("入场价", text: $entry).keyboardType(.decimalPad)
                        TextField("止损价", text: $stopLoss).keyboardType(.decimalPad)
                        TextField("买入仓位", text: $quantity).keyboardType(.numberPad)
                    } else if actionToday == "部分止盈" {
                        TextField("止盈价", text: $takeProfit).keyboardType(.decimalPad)
                        TextField("卖出仓位", text: $quantity).keyboardType(.numberPad)
                    } else if actionToday == "止损" {
                        TextField("止损价", text: $stopLoss).keyboardType(.decimalPad)
                        TextField("卖出仓位", text: $quantity).keyboardType(.numberPad)
                    }
                }
                if let rec = todayRecord {
                    Section(header: Text("计划操作")) {
                        Text(rec.plannedAction)
                    }
                }
                Section(header: Text("备注")) {
                    TextField("备注", text: $notes, axis: .vertical)
                }
            }
            .navigationTitle("更新今日计划")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存并下一步") { saveAndClose() }
                }
            }
        }
        .onAppear { populate() }
    }

    private func populate() {
        if let rec = todayRecord {
            actionToday = rec.actionToday
            entry = rec.entryPrice != 0 ? String(rec.entryPrice) : ""
            stopLoss = rec.stopLoss != 0 ? String(rec.stopLoss) : ""
            takeProfit = rec.takeProfitPrice != 0 ? String(rec.takeProfitPrice) : ""
            quantity = rec.buyQuantity != 0 ? String(rec.buyQuantity) : ""
            notes = rec.notes ?? ""
        }
    }

    private func saveAndClose() {
        guard let rec = todayRecord else { onComplete(); return }
        rec.actionToday = actionToday
        rec.notes = notes
        rec.entryPrice = Double(entry) ?? 0
        rec.stopLoss = Double(stopLoss) ?? 0
        rec.takeProfitPrice = Double(takeProfit) ?? 0
        if actionToday == "建仓" {
            rec.buyQuantity = Int32(quantity) ?? 0
        } else {
            rec.sellQuantity = Int32(quantity) ?? 0
        }
        store.performDailyMigrations()
        onComplete()
    }
}
