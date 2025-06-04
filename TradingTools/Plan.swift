import Foundation
import CoreData

@objc(Plan)
public class Plan: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var symbol: String
    @NSManaged public var strategy: String
    @NSManaged public var createdAt: Date
    @NSManaged public var records: Set<Record>
}

extension Plan {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plan> {
        NSFetchRequest<Plan>(entityName: "Plan")
    }
}
