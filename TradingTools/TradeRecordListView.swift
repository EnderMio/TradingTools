import SwiftUI
import CoreData

struct TradeRecordListView: View {
    @FetchRequest(
        entity: TradeRecord.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TradeRecord.date, ascending: false)]
    ) private var records: FetchedResults<TradeRecord>

    var body: some View {
        List {
            ForEach(records) { record in
                VStack(alignment: .leading) {
                    HStack {
                        Text(record.date, style: .date)
                        Spacer()
                        Text(String(format: "%.2f", record.exitPrice - record.entryPrice))
                    }
                    .font(.subheadline)
                    Text("入 \(record.entryPrice, specifier: \"%.2f\") -> 出 \(record.exitPrice, specifier: \"%.2f\")")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("交易记录")
    }
}

#Preview {
    TradeRecordListView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
