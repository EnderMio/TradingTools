import SwiftUI
import CoreData

struct RecordEditView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    let plan: TradePlan
    @State private var entry: String = ""
    @State private var exit: String = ""
    @State private var quantity: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("入场价", text: $entry)
                    .keyboardType(.decimalPad)
                TextField("出场价", text: $exit)
                    .keyboardType(.decimalPad)
                TextField("数量", text: $quantity)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("新增记录")
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
        guard let e = Double(entry), let x = Double(exit), let q = Double(quantity) else { return }
        let record = TradeRecord(context: context)
        record.id = UUID()
        record.planID = plan.id
        record.entryPrice = e
        record.exitPrice = x
        record.quantity = q
        record.date = Date()
        try? context.save()
        dismiss()
    }
}

#Preview {
    RecordEditView(plan: TradePlan(symbol: "AAPL", strategy: "", direction: .long, entryPrice: 10, stopLoss: 9, notes: ""))
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
