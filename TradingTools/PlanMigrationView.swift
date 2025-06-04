import SwiftUI

struct PlanMigrationView: View {
    let plan: TradePlan
    @ObservedObject var store: TradePlanStore
    var onComplete: () -> Void

    @State private var todayAction: TradeStatus
    @State private var plannedAction: PlanAction
    @State private var entry: String
    @State private var stopLoss: String
    @State private var takeProfit: String
    @State private var quantity: String
    @State private var actionTime: Date
    @State private var notes: String

    init(plan: TradePlan, store: TradePlanStore, onComplete: @escaping () -> Void) {
        self.plan = plan
        self.store = store
        self.onComplete = onComplete
        _todayAction = State(initialValue: plan.plannedAction == .build ? .build : .none)
        _plannedAction = State(initialValue: plan.plannedAction)
        _entry = State(initialValue: plan.entryPrice.map { String($0) } ?? "")
        _stopLoss = State(initialValue: plan.stopLoss.map { String($0) } ?? "")
        _takeProfit = State(initialValue: plan.takeProfitPrice.map { String($0) } ?? "")
        _quantity = State(initialValue: plan.quantity.map { String($0) } ?? "")
        _actionTime = State(initialValue: plan.actionTime)
        _notes = State(initialValue: plan.notes)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("品种")) {
                    Text(plan.symbol)
                    Text(plan.strategy)
                }
                Section(header: Text("今日操作")) {
                    Picker("状态", selection: $todayAction) {
                        ForEach(TradeStatus.allCases) { st in
                            Text(st.rawValue).tag(st)
                        }
                    }
                    switch todayAction {
                    case .build:
                        TextField("入场价", text: $entry)
                            .keyboardType(.decimalPad)
                        TextField("止损价", text: $stopLoss)
                            .keyboardType(.decimalPad)
                        TextField("买入仓位", text: $quantity)
                            .keyboardType(.decimalPad)
                    case .partial:
                        TextField("止盈价", text: $takeProfit)
                            .keyboardType(.decimalPad)
                        TextField("卖出仓位", text: $quantity)
                            .keyboardType(.decimalPad)
                    case .stopLoss:
                        TextField("止损价", text: $stopLoss)
                            .keyboardType(.decimalPad)
                        TextField("卖出仓位", text: $quantity)
                            .keyboardType(.decimalPad)
                    default:
                        EmptyView()
                    }
                }
                Section(header: Text("计划操作")) {
                    Picker("操作", selection: $plannedAction) {
                        ForEach(PlanAction.allCases) { ac in
                            Text(ac.rawValue).tag(ac)
                        }
                    }
                    if plannedAction == .build {
                        DatePicker("操作时间", selection: $actionTime, displayedComponents: .hourAndMinute)
                    }
                }
                Section(header: Text("备注")) {
                    TextField("备注", text: $notes)
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
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: plan.date) ?? plan.date
        let entryP = Double(entry)
        let sl = Double(stopLoss)
        let qty = Double(quantity)
        let tp = Double(takeProfit)
        let newPlan = TradePlan(symbol: plan.symbol,
                               strategy: plan.strategy,
                               direction: plan.direction,
                               date: nextDate,
                               actionTime: actionTime,
                               plannedAction: plannedAction,
                               takeProfitCondition: plan.takeProfitCondition,
                               entryPrice: entryP,
                               stopLoss: sl,
                               takeProfitPrice: tp,
                               quantity: qty,
                               notes: notes,
                               status: todayAction)
        store.add(newPlan)
        onComplete()
    }
}

#Preview {
    PlanMigrationView(plan: TradePlan(symbol: "AAPL", strategy: "", direction: .long, notes: ""), store: TradePlanStore()) {}
}
