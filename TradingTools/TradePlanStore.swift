import Foundation
import SwiftUI

@MainActor
class TradePlanStore: ObservableObject {
    @Published var plans: [TradePlan] = []
    private let fileURL: URL

    init() {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = url.appendingPathComponent("plans.json")
        load()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let items = try? JSONDecoder().decode([TradePlan].self, from: data) {
            plans = items
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(plans) else { return }
        try? data.write(to: fileURL)
    }

    func add(_ plan: TradePlan) {
        plans.append(plan)
        save()
    }

    func delete(at offsets: IndexSet) {
        plans.remove(atOffsets: offsets)
        save()
    }
}
