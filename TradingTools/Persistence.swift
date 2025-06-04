import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let model = NSManagedObjectModel()

        // Record entity
        let recordEntity = NSEntityDescription()
        recordEntity.name = "Record"
        recordEntity.managedObjectClassName = NSStringFromClass(Record.self)

        var recordProps: [NSPropertyDescription] = []

        let recordId = NSAttributeDescription()
        recordId.name = "id"
        recordId.attributeType = .UUIDAttributeType
        recordId.isOptional = false
        recordProps.append(recordId)

        let recordDate = NSAttributeDescription()
        recordDate.name = "date"
        recordDate.attributeType = .dateAttributeType
        recordDate.isOptional = false
        recordProps.append(recordDate)

        let actToday = NSAttributeDescription()
        actToday.name = "actionToday"
        actToday.attributeType = .stringAttributeType
        actToday.isOptional = false
        recordProps.append(actToday)

        let planAction = NSAttributeDescription()
        planAction.name = "plannedAction"
        planAction.attributeType = .stringAttributeType
        planAction.isOptional = false
        recordProps.append(planAction)

        let entryP = NSAttributeDescription()
        entryP.name = "entryPrice"
        entryP.attributeType = .doubleAttributeType
        entryP.isOptional = true
        recordProps.append(entryP)

        let stop = NSAttributeDescription()
        stop.name = "stopLoss"
        stop.attributeType = .doubleAttributeType
        stop.isOptional = true
        recordProps.append(stop)

        let tp = NSAttributeDescription()
        tp.name = "takeProfitPrice"
        tp.attributeType = .doubleAttributeType
        tp.isOptional = true
        recordProps.append(tp)

        let buyQty = NSAttributeDescription()
        buyQty.name = "buyQuantity"
        buyQty.attributeType = .integer32AttributeType
        buyQty.isOptional = true
        recordProps.append(buyQty)

        let sellQty = NSAttributeDescription()
        sellQty.name = "sellQuantity"
        sellQty.attributeType = .integer32AttributeType
        sellQty.isOptional = true
        recordProps.append(sellQty)

        let opTime = NSAttributeDescription()
        opTime.name = "operationTime"
        opTime.attributeType = .dateAttributeType
        opTime.isOptional = true
        recordProps.append(opTime)

        let noteAttr = NSAttributeDescription()
        noteAttr.name = "notes"
        noteAttr.attributeType = .stringAttributeType
        noteAttr.isOptional = true
        recordProps.append(noteAttr)

        let planRel = NSRelationshipDescription()
        planRel.name = "plan"
        planRel.destinationEntity = nil // placeholder
        planRel.minCount = 1
        planRel.maxCount = 1
        planRel.deleteRule = .nullifyDeleteRule
        recordProps.append(planRel)

        recordEntity.properties = recordProps

        // Plan entity
        let planEntity = NSEntityDescription()
        planEntity.name = "Plan"
        planEntity.managedObjectClassName = NSStringFromClass(Plan.self)

        var planProps: [NSPropertyDescription] = []

        let planId = NSAttributeDescription()
        planId.name = "id"
        planId.attributeType = .UUIDAttributeType
        planId.isOptional = false
        planProps.append(planId)

        let symAttr = NSAttributeDescription()
        symAttr.name = "symbol"
        symAttr.attributeType = .stringAttributeType
        symAttr.isOptional = false
        planProps.append(symAttr)

        let stratAttr = NSAttributeDescription()
        stratAttr.name = "strategy"
        stratAttr.attributeType = .stringAttributeType
        stratAttr.isOptional = false
        planProps.append(stratAttr)

        let createAttr = NSAttributeDescription()
        createAttr.name = "createdAt"
        createAttr.attributeType = .dateAttributeType
        createAttr.isOptional = false
        planProps.append(createAttr)

        let recsRel = NSRelationshipDescription()
        recsRel.name = "records"
        recsRel.destinationEntity = recordEntity
        recsRel.minCount = 0
        recsRel.maxCount = 0
        recsRel.deleteRule = .cascadeDeleteRule
        recsRel.isOptional = true
        planProps.append(recsRel)

        planEntity.properties = planProps

        // connect plan relation destination
        planRel.destinationEntity = planEntity
        planRel.inverseRelationship = recsRel
        recsRel.inverseRelationship = planRel

        // TradeRecord entity
        let tRecordEntity = NSEntityDescription()
        tRecordEntity.name = "TradeRecord"
        tRecordEntity.managedObjectClassName = NSStringFromClass(TradeRecord.self)

        var tRecordProps: [NSPropertyDescription] = []

        let trId = NSAttributeDescription()
        trId.name = "id"
        trId.attributeType = .UUIDAttributeType
        trId.isOptional = false
        tRecordProps.append(trId)

        let trPlan = NSAttributeDescription()
        trPlan.name = "planID"
        trPlan.attributeType = .UUIDAttributeType
        trPlan.isOptional = false
        tRecordProps.append(trPlan)

        let trEntry = NSAttributeDescription()
        trEntry.name = "entryPrice"
        trEntry.attributeType = .doubleAttributeType
        trEntry.isOptional = false
        tRecordProps.append(trEntry)

        let trExit = NSAttributeDescription()
        trExit.name = "exitPrice"
        trExit.attributeType = .doubleAttributeType
        trExit.isOptional = false
        tRecordProps.append(trExit)

        let trQty = NSAttributeDescription()
        trQty.name = "quantity"
        trQty.attributeType = .doubleAttributeType
        trQty.isOptional = false
        tRecordProps.append(trQty)

        let trDate = NSAttributeDescription()
        trDate.name = "date"
        trDate.attributeType = .dateAttributeType
        trDate.isOptional = false
        tRecordProps.append(trDate)

        tRecordEntity.properties = tRecordProps

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

        model.entities = [planEntity, recordEntity, tRecordEntity, logEntity]

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
