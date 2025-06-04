import SwiftUI

struct PlanListView: View {
    @ObservedObject var store: TradePlanStore
    @State private var showAdd = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.plans) { plan in
                    NavigationLink(value: plan.id) {
                        PlanRowView(plan: plan)
                    }
                }
                .onDelete(perform: store.delete)
            }
            .navigationTitle("交易计划")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAdd = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                PlanEditView(store: store)
            }
            .navigationDestination(for: UUID.self) { id in
                if let index = store.plans.firstIndex(where: { $0.id == id }) {
                    PlanDetailView(plan: $store.plans[index])
                }
            }
        }
    }
}

struct PlanListView_Previews: PreviewProvider {
    static var previews: some View {
        PlanListView(store: TradePlanStore())
    }
}
