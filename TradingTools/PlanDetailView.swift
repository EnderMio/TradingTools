import SwiftUI

struct PlanDetailView: View {
    @Binding var plan: TradePlan
    @Environment(\.managedObjectContext) private var context

    @FetchRequest private var records: FetchedResults<TradeRecord>
    @FetchRequest private var logs: FetchedResults<TradeLog>
    @State private var showAddRecord = false
    @State private var showAddLog = false

    init(plan: Binding<TradePlan>) {
        _plan = plan
        let recordReq: NSFetchRequest<TradeRecord> = TradeRecord.fetchRequest()
        recordReq.sortDescriptors = [NSSortDescriptor(keyPath: \TradeRecord.date, ascending: false)]
        recordReq.predicate = NSPredicate(format: "planID == %@", plan.wrappedValue.id as CVarArg)
        _records = FetchRequest(fetchRequest: recordReq)

        let logReq: NSFetchRequest<TradeLog> = TradeLog.fetchRequest()
        logReq.sortDescriptors = [NSSortDescriptor(keyPath: \TradeLog.date, ascending: false)]
        logReq.predicate = NSPredicate(format: "planID == %@", plan.wrappedValue.id as CVarArg)
        _logs = FetchRequest(fetchRequest: logReq)
    }

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
            Section(header: Text("记录")) {
                if records.isEmpty {
                    Text("暂无记录")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(records) { r in
                        HStack {
                            Text(r.date, style: .date)
                            Spacer()
                            Text(String(format: "%.2f", r.exitPrice - r.entryPrice))
                        }
                        .font(.footnote)
                    }
                }
                Button("新增记录") { showAddRecord = true }
            }
            Section(header: Text("日志")) {
                if logs.isEmpty {
                    Text("暂无日志")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(logs) { log in
                        HStack {
                            Text(log.date, style: .date)
                            Spacer()
                            Text("评分 \(log.rating)")
                        }
                        .font(.footnote)
                        .lineLimit(1)
                    }
                }
                Button("新增日志") { showAddLog = true }
            }
        }
        .navigationTitle(plan.symbol)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddRecord) {
            RecordEditView(plan: plan)
                .environment(\.managedObjectContext, context)
        }
        .sheet(isPresented: $showAddLog) {
            LogEditView(planID: plan.id)
                .environment(\.managedObjectContext, context)
        }
    }
}

struct PlanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlanDetailView(plan: .constant(TradePlan(symbol: "TSLA", direction: .long, entryPrice: 100, stopLoss: 90, notes: "")))
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
