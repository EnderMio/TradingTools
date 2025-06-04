import SwiftUI

struct PlanListView: View {
    @ObservedObject var store: PlanStore
    @State private var showAddPlan = false
    @State private var pendingMigrations: [Plan] = []
    @State private var currentIndex = 0
    @State private var showMigrationSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.plans) { plan in
                    let recs = plan.records
                    let last = recs.max(by: { $0.date < $1.date })
                    NavigationLink(value: plan.id) {
                        PlanRowView(plan: plan, latest: last)
                            .padding(.vertical, 4)
                    }
                }
                .onDelete { indexSet in
                    indexSet.compactMap { store.plans[$0] }.forEach(store.deletePlan)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("交易计划")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddPlan = true }) { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showAddPlan) {
                PlanEditView(store: store)
            }
            .sheet(isPresented: $showMigrationSheet) {
                if currentIndex < pendingMigrations.count {
                    MigrationFormView(plan: pendingMigrations[currentIndex], store: store) {
                        advanceMigration()
                    }
                }
            }
            .navigationDestination(for: UUID.self) { id in
                if let plan = store.plans.first(where: { $0.id == id }) {
                    PlanDetailView(plan: plan, store: store)
                }
            }
            .onAppear {
                store.performDailyMigrations()
                collectPendingMigrations()
            }
        }
    }

    private func collectPendingMigrations() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        pendingMigrations = store.plans.filter { plan in
            guard let last = plan.records.max(by: { $0.date < $1.date }) else { return false }
            return calendar.isDate(last.date, inSameDayAs: today) && last.actionToday == "无"
        }
        if !pendingMigrations.isEmpty {
            currentIndex = 0
            showMigrationSheet = true
        }
    }

    private func advanceMigration() {
        currentIndex += 1
        if currentIndex >= pendingMigrations.count {
            showMigrationSheet = false
            pendingMigrations = []
        }
    }
}

struct PlanListView_Previews: PreviewProvider {
    static var previews: some View {
        PlanListView(store: PlanStore(context: PersistenceController.shared.container.viewContext))
    }
}
