import Foundation
import CoreData

@objc(Record)
public class Record: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var actionToday: String
    @NSManaged public var plannedAction: String
    @NSManaged public var entryPrice: Double
    @NSManaged public var stopLoss: Double
    @NSManaged public var takeProfitPrice: Double
    @NSManaged public var buyQuantity: Int32
    @NSManaged public var sellQuantity: Int32
    @NSManaged public var operationTime: Date?
    @NSManaged public var notes: String?
    @NSManaged public var plan: Plan
}

extension Record {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        NSFetchRequest<Record>(entityName: "Record")
    }
}
