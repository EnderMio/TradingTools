import Foundation
import CoreData

@objc(TradeLog)
public class TradeLog: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var planID: UUID?
    @NSManaged public var text: String
    @NSManaged public var date: Date
    @NSManaged public var rating: Int16
}

extension TradeLog {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TradeLog> {
        NSFetchRequest<TradeLog>(entityName: "TradeLog")
    }
}
