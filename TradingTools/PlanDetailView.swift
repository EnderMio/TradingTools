import SwiftUI
import CoreData

struct PlanDetailView: View {
    let plan: Plan
    @ObservedObject var store: PlanStore

    private var sortedRecords: [Record] {
        Array(plan.records).sorted { $0.date > $1.date }
    }

    var body: some View {
        List {
            Section(header: Text("主计划信息")) {
                HStack { Text("品种："); Spacer(); Text(plan.symbol) }
                HStack { Text("策略："); Spacer(); Text(plan.strategy) }
                HStack { Text("创建日期："); Spacer(); Text(plan.createdAt, style: .date) }
            }
            Section(header: Text("历史记录")) {
                if sortedRecords.isEmpty {
                    Text("暂无历史记录").foregroundColor(.secondary)
                } else {
                    ForEach(sortedRecords, id: \ .id) { rec in
                        RecordRowView(record: rec)
                    }
                }
            }
            if let todayRec = sortedRecords.first,
               Calendar.current.isDate(todayRec.date, inSameDayAs: Date()),
               todayRec.actionToday == "无" {
                Section {
                    Button("填写今日操作") { }
                }
            }
        }
        .navigationTitle(plan.symbol)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RecordRowView: View {
    let record: Record
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(record.date, style: .date).font(.headline)
                Spacer()
                Text(record.actionToday).font(.subheadline).foregroundColor(.secondary)
            }
            HStack {
                if record.entryPrice != 0 { Text("入：\(String(format: "%.2f", record.entryPrice))") }
                if record.stopLoss != 0 { Text("止损：\(String(format: "%.2f", record.stopLoss))") }
                if record.takeProfitPrice != 0 { Text("止盈：\(String(format: "%.2f", record.takeProfitPrice))") }
                if record.buyQuantity != 0 { Text("买：\(record.buyQuantity)") }
                if record.sellQuantity != 0 { Text("卖：\(record.sellQuantity)") }
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 6)
    }
}
