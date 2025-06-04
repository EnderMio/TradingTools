import Foundation

enum TradeDirection: String, Codable, CaseIterable, Identifiable {
    case long = "多"
    case short = "空"

    var id: String { rawValue }
}

enum TradeStatus: String, Codable, CaseIterable, Identifiable {
    case none = "无"
    case build = "建仓"
    case hold = "持有"
    case partial = "部分止盈"
    case stopLoss = "止损"

    var id: String { rawValue }
}

enum PlanAction: String, Codable, CaseIterable, Identifiable {
    case none = "无"
    case build = "建仓"
    case check = "检查止盈止损"

    var id: String { rawValue }
}

struct TradePlan: Identifiable, Codable {
    var id: UUID = UUID()
    var symbol: String
    var strategy: String = ""
    var direction: TradeDirection
    /// The date this plan is intended for
    var date: Date = .now
    /// Planned time to operate
    var actionTime: Date = .now
    /// Next day's planned operation
    var plannedAction: PlanAction = .none
    /// Condition to take profit
    var takeProfitCondition: String = ""
    var entryPrice: Double?
    var stopLoss: Double?
    var takeProfitPrice: Double?
    var quantity: Double?
    var notes: String
    /// Today's actual operation
    var status: TradeStatus = .none

    init(id: UUID = UUID(),
         symbol: String,
         strategy: String = "",
         direction: TradeDirection,
         date: Date = .now,
         actionTime: Date = .now,
         plannedAction: PlanAction = .none,
         takeProfitCondition: String = "",
         entryPrice: Double? = nil,
         stopLoss: Double? = nil,
         takeProfitPrice: Double? = nil,
         quantity: Double? = nil,
         notes: String,
         status: TradeStatus = .none) {
        self.id = id
        self.symbol = symbol
        self.strategy = strategy
        self.direction = direction
        self.date = date
        self.actionTime = actionTime
        self.plannedAction = plannedAction
        self.takeProfitCondition = takeProfitCondition
        self.entryPrice = entryPrice
        self.stopLoss = stopLoss
        self.takeProfitPrice = takeProfitPrice
        self.quantity = quantity
        self.notes = notes
        self.status = status
    }

    enum CodingKeys: String, CodingKey {
        case id, symbol, strategy, direction, date, actionTime, plannedAction, takeProfitCondition, entryPrice, stopLoss, takeProfitPrice, quantity, notes, status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        symbol = try container.decode(String.self, forKey: .symbol)
        strategy = try container.decodeIfPresent(String.self, forKey: .strategy) ?? ""
        direction = try container.decode(TradeDirection.self, forKey: .direction)
        date = try container.decodeIfPresent(Date.self, forKey: .date) ?? .now
        actionTime = try container.decodeIfPresent(Date.self, forKey: .actionTime) ?? .now
        plannedAction = try container.decodeIfPresent(PlanAction.self, forKey: .plannedAction) ?? .none
        takeProfitCondition = try container.decodeIfPresent(String.self, forKey: .takeProfitCondition) ?? ""
        entryPrice = try container.decodeIfPresent(Double.self, forKey: .entryPrice)
        stopLoss = try container.decodeIfPresent(Double.self, forKey: .stopLoss)
        takeProfitPrice = try container.decodeIfPresent(Double.self, forKey: .takeProfitPrice)
        quantity = try container.decodeIfPresent(Double.self, forKey: .quantity)
        notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
        status = try container.decodeIfPresent(TradeStatus.self, forKey: .status) ?? .none
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(strategy, forKey: .strategy)
        try container.encode(direction, forKey: .direction)
        try container.encode(date, forKey: .date)
        try container.encode(actionTime, forKey: .actionTime)
        try container.encode(plannedAction, forKey: .plannedAction)
        try container.encode(takeProfitCondition, forKey: .takeProfitCondition)
        try container.encodeIfPresent(entryPrice, forKey: .entryPrice)
        try container.encodeIfPresent(stopLoss, forKey: .stopLoss)
        try container.encodeIfPresent(takeProfitPrice, forKey: .takeProfitPrice)
        try container.encodeIfPresent(quantity, forKey: .quantity)
        try container.encode(notes, forKey: .notes)
        try container.encode(status, forKey: .status)
    }
}
