import SwiftUI

struct PlanListView: View {
    @ObservedObject var store: TradePlanStore
    @State private var showAdd = false
    @State private var filter: PlanFilter = .all
    @State private var migrationIndices: [Int] = []
    @State private var currentMigration = 0
    @State private var showMigration = false

    enum PlanFilter: String, CaseIterable, Identifiable {
        case all = "全部"
        case pending = "待执行"
        case open = "持仓"
        case closed = "已平仓"

        var id: String { rawValue }
    }

    private var filteredPlans: [TradePlan] {
        let sorted = store.plans.sorted { $0.date < $1.date }
        switch filter {
        case .all:
            return sorted
        case .pending:
            return sorted.filter { $0.status == .pending }
        case .open:
            return sorted.filter { $0.status == .open }
        case .closed:
            return sorted.filter { $0.status == .closed }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("筛选", selection: $filter) {
                    ForEach(PlanFilter.allCases) { f in
                        Text(f.rawValue).tag(f)
                    }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .top])

                List {
                    ForEach(filteredPlans) { plan in
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
                    PlanMigrationView(plan: $store.plans[idx]) {
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
        migrationIndices = store.plans.indices.filter { store.plans[$0].date <= today }
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
