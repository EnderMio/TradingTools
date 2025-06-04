import SwiftUI
import CoreData

struct TradeLogListView: View {
    @FetchRequest(
        entity: TradeLog.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TradeLog.date, ascending: false)]
    ) private var logs: FetchedResults<TradeLog>

    var body: some View {
        List {
            ForEach(logs) { log in
                VStack(alignment: .leading) {
                    HStack {
                        Text(log.date, style: .date)
                        Spacer()
                        Text("评分 \(log.rating)")
                    }
                    .font(.subheadline)
                    Text(log.text)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .navigationTitle("交易日志")
    }
}

#Preview {
    TradeLogListView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
