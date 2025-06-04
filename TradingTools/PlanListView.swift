import SwiftUI

struct PlanListView: View {
    @ObservedObject var store: TradePlanStore
    @State private var showAdd = false
    @State private var migrationIndices: [Int] = []
    @State private var currentMigration = 0
    @State private var showMigration = false

    private var sortedPlans: [TradePlan] {
        store.plans.sorted { $0.date < $1.date }
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(sortedPlans) { plan in
                        NavigationLink(value: plan.id) {
                            PlanRowView(plan: plan)
                                .padding(.vertical, 4)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: store.delete)
                }
                .listStyle(.insetGrouped)
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
            .sheet(isPresented: $showMigration) {
                if !migrationIndices.isEmpty {
                    let idx = migrationIndices[currentMigration]
                    PlanMigrationView(plan: store.plans[idx], store: store) {
                        advanceMigration()
                    }
                }
            }
            .navigationDestination(for: UUID.self) { id in
                if let index = store.plans.firstIndex(where: { $0.id == id }) {
                    PlanDetailView(plan: $store.plans[index])
                        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                }
            }
            .onAppear {
                prepareMigration()
            }
        }
    }

    private func prepareMigration() {
        let today = Calendar.current.startOfDay(for: Date())
        migrationIndices = store.plans.indices.filter { store.plans[$0].date < today }
        currentMigration = 0
        showMigration = !migrationIndices.isEmpty
    }

    private func advanceMigration() {
        currentMigration += 1
        if currentMigration >= migrationIndices.count {
            showMigration = false
            migrationIndices = []
            currentMigration = 0
            store.save()
        }
    }
}

struct PlanListView_Previews: PreviewProvider {
    static var previews: some View {
        PlanListView(store: TradePlanStore())
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
