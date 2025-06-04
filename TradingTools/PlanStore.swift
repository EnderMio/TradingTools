import Foundation
import CoreData
import Combine

class PlanStore: ObservableObject {
    private let context: NSManagedObjectContext
    @Published var plans: [Plan] = []

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchAll()
    }

    func fetchAll() {
        let req: NSFetchRequest<Plan> = Plan.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(keyPath: \Plan.createdAt, ascending: true)]
        do {
            plans = try context.fetch(req)
        } catch {
            plans = []
        }
    }

    func addNewPlan(symbol: String, strategy: String, firstDate: Date, actionTime: Date, entryPrice: Double?, stopLoss: Double?, buyQty: Int32?, notes: String?) {
        let plan = Plan(context: context)
        plan.id = UUID()
        plan.symbol = symbol
        plan.strategy = strategy
        plan.createdAt = firstDate

        let rec = Record(context: context)
        rec.id = UUID()
        rec.date = firstDate
        rec.actionToday = "无"
        rec.plannedAction = "建仓"
        rec.operationTime = actionTime
        rec.entryPrice = entryPrice ?? 0
        rec.stopLoss = stopLoss ?? 0
        rec.buyQuantity = buyQty ?? 0
        rec.sellQuantity = 0
        rec.takeProfitPrice = 0
        rec.plan = plan
        rec.notes = notes

        save()
        fetchAll()
    }

    func performDailyMigrations() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        for plan in plans {
            let records = plan.records
            guard let last = records.max(by: { $0.date < $1.date }) else { continue }
            if calendar.startOfDay(for: last.date) < today {
                migrate(plan: plan, from: last)
            }
        }
        fetchAll()
    }

    private func migrate(plan: Plan, from last: Record) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let rec = Record(context: context)
        rec.id = UUID()
        rec.date = today
        rec.operationTime = last.operationTime
        rec.plan = plan
        rec.actionToday = "无"
        if last.plannedAction == "建仓" {
            rec.plannedAction = "检查止盈止损"
        } else if last.plannedAction == "检查止盈止损" {
            rec.plannedAction = "检查止盈止损"
        } else {
            rec.plannedAction = "无"
        }
        save()
    }

    func deletePlan(_ plan: Plan) {
        context.delete(plan)
        save()
        fetchAll()
    }

    private func save() {
        if context.hasChanges {
            do { try context.save() } catch { }
        }
    }
}
