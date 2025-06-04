import Foundation
import CoreData

@objc(TradeRecord)
public class TradeRecord: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var planID: UUID
    @NSManaged public var entryPrice: Double
    @NSManaged public var exitPrice: Double
    @NSManaged public var quantity: Double
    @NSManaged public var date: Date
}

extension TradeRecord {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TradeRecord> {
        NSFetchRequest<TradeRecord>(entityName: "TradeRecord")
    }
}
