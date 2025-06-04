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
    var entryPrice: Double
    var stopLoss: Double
    var notes: String
    var status: TradeStatus = .pending
}
