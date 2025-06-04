import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let model = NSManagedObjectModel()

        // TradeRecord entity
        let recordEntity = NSEntityDescription()
        recordEntity.name = "TradeRecord"
        recordEntity.managedObjectClassName = NSStringFromClass(TradeRecord.self)

        var properties: [NSAttributeDescription] = []

        let idAttr = NSAttributeDescription()
        idAttr.name = "id"
        idAttr.attributeType = .UUIDAttributeType
        idAttr.isOptional = false
        properties.append(idAttr)

        let planIDAttr = NSAttributeDescription()
        planIDAttr.name = "planID"
        planIDAttr.attributeType = .UUIDAttributeType
        planIDAttr.isOptional = false
        properties.append(planIDAttr)

        let entryAttr = NSAttributeDescription()
        entryAttr.name = "entryPrice"
        entryAttr.attributeType = .doubleAttributeType
        entryAttr.isOptional = false
        properties.append(entryAttr)

        let exitAttr = NSAttributeDescription()
        exitAttr.name = "exitPrice"
        exitAttr.attributeType = .doubleAttributeType
        exitAttr.isOptional = false
        properties.append(exitAttr)

        let qtyAttr = NSAttributeDescription()
        qtyAttr.name = "quantity"
        qtyAttr.attributeType = .doubleAttributeType
        qtyAttr.isOptional = false
        properties.append(qtyAttr)

        let dateAttr = NSAttributeDescription()
        dateAttr.name = "date"
        dateAttr.attributeType = .dateAttributeType
        dateAttr.isOptional = false
        properties.append(dateAttr)

        recordEntity.properties = properties

        // TradeLog entity
        let logEntity = NSEntityDescription()
        logEntity.name = "TradeLog"
        logEntity.managedObjectClassName = NSStringFromClass(TradeLog.self)

        var logProps: [NSAttributeDescription] = []

        let logId = NSAttributeDescription()
        logId.name = "id"
        logId.attributeType = .UUIDAttributeType
        logId.isOptional = false
        logProps.append(logId)

        let logPlan = NSAttributeDescription()
        logPlan.name = "planID"
        logPlan.attributeType = .UUIDAttributeType
        logPlan.isOptional = true
        logProps.append(logPlan)

        let logText = NSAttributeDescription()
        logText.name = "text"
        logText.attributeType = .stringAttributeType
        logText.isOptional = false
        logProps.append(logText)

        let logDate = NSAttributeDescription()
        logDate.name = "date"
        logDate.attributeType = .dateAttributeType
        logDate.isOptional = false
        logProps.append(logDate)

        let logRating = NSAttributeDescription()
        logRating.name = "rating"
        logRating.attributeType = .integer16AttributeType
        logRating.isOptional = false
        logProps.append(logRating)

        logEntity.properties = logProps

        model.entities = [recordEntity, logEntity]

        container = NSPersistentContainer(name: "TradingToolsModel", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
