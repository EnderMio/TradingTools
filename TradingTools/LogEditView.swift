import SwiftUI
import CoreData

struct LogEditView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    let planID: UUID?
    @State private var text: String = ""
    @State private var rating: Int = 3

    var body: some View {
        NavigationStack {
            Form {
                TextEditor(text: $text)
                    .frame(minHeight: 120)
                Picker("评分", selection: $rating) {
                    ForEach(1..<6) { i in
                        Text(String(i)).tag(i)
                    }
                }
                .pickerStyle(.segmented)
            }
            .navigationTitle("新增日志")
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
        let log = TradeLog(context: context)
        log.id = UUID()
        log.planID = planID
        log.text = text
        log.date = Date()
        log.rating = Int16(rating)
        try? context.save()
        dismiss()
    }
}

#Preview {
    LogEditView(planID: nil)
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
