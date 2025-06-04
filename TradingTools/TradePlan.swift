import Foundation

enum TradeDirection: String, Codable, CaseIterable, Identifiable {
    case long = "多"
    case short = "空"

    var id: String { rawValue }
}

enum TradeStatus: String, Codable, CaseIterable, Identifiable {
    case pending = "待执行"
    case open = "已执行"
    case closed = "已平仓"
    case cancelled = "已取消"

    var id: String { rawValue }
}

struct TradePlan: Identifiable, Codable {
    var id: UUID = UUID()
    var symbol: String
    var direction: TradeDirection
    /// The date this plan is intended for
    var date: Date = .now
    /// Planned time to operate
    var actionTime: Date = .now
    /// Condition to take profit
    var takeProfitCondition: String = ""
    var entryPrice: Double
    var stopLoss: Double
    var notes: String
    var status: TradeStatus = .pending

    init(id: UUID = UUID(),
         symbol: String,
         direction: TradeDirection,
         date: Date = .now,
         actionTime: Date = .now,
         takeProfitCondition: String = "",
         entryPrice: Double,
         stopLoss: Double,
         notes: String,
         status: TradeStatus = .pending) {
        self.id = id
        self.symbol = symbol
        self.direction = direction
        self.date = date
        self.actionTime = actionTime
        self.takeProfitCondition = takeProfitCondition
        self.entryPrice = entryPrice
        self.stopLoss = stopLoss
        self.notes = notes
        self.status = status
    }

    enum CodingKeys: String, CodingKey {
        case id, symbol, direction, date, actionTime, takeProfitCondition, entryPrice, stopLoss, notes, status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        symbol = try container.decode(String.self, forKey: .symbol)
        direction = try container.decode(TradeDirection.self, forKey: .direction)
        date = try container.decodeIfPresent(Date.self, forKey: .date) ?? .now
        actionTime = try container.decodeIfPresent(Date.self, forKey: .actionTime) ?? .now
        takeProfitCondition = try container.decodeIfPresent(String.self, forKey: .takeProfitCondition) ?? ""
        entryPrice = try container.decode(Double.self, forKey: .entryPrice)
        stopLoss = try container.decode(Double.self, forKey: .stopLoss)
        notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
        status = try container.decodeIfPresent(TradeStatus.self, forKey: .status) ?? .pending
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(direction, forKey: .direction)
        try container.encode(date, forKey: .date)
        try container.encode(actionTime, forKey: .actionTime)
        try container.encode(takeProfitCondition, forKey: .takeProfitCondition)
        try container.encode(entryPrice, forKey: .entryPrice)
        try container.encode(stopLoss, forKey: .stopLoss)
        try container.encode(notes, forKey: .notes)
        try container.encode(status, forKey: .status)
    }
}
