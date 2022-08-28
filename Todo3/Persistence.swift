//
//  Persistence.swift
//  Todo2
//
//  Created by Tim Yoon on 8/8/22.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentCloudKitContainer
    let context : NSManagedObjectContext

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "CoredataModel")
        container.persistentStoreDescriptions.first!.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        context = container.viewContext
        context.undoManager = UndoManager()
    }
    func save(){
        do{
            try container.viewContext.save()
        }catch let error {
            print("Error saving Core Data. \(error.localizedDescription)")
        }
    }
    func undo(){
        context.undo()
    }
    func redo(){
        context.redo()
    }
    func beginUndoGrouping(){
        context.undoManager?.beginUndoGrouping()
    }
    func endUndoGrouping(){
        context.undoManager?.endUndoGrouping()
    }
}
