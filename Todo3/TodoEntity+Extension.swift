//
//  TodoEntity+Extension.swift
//  Todo2
//
//  Created by Tim Yoon on 8/13/22.
//

import Foundation
import CoreData
extension TodoEntity {
    static let sortByListOrder = [
        NSSortDescriptor(key: "isDone", ascending: true),
        NSSortDescriptor(key: "listOrder", ascending: false)
    ]
    static let sortByAll = [
        NSSortDescriptor(key: "isDone", ascending: true),
        NSSortDescriptor(key: "category.name", ascending: true),
        NSSortDescriptor(key: "priority", ascending: false),
        NSSortDescriptor(key: "duration", ascending: true),
        NSSortDescriptor(key: "dueDate", ascending: true)
    ]
    static let sortByCategory = [
        NSSortDescriptor(key: "isDone", ascending: true),
        NSSortDescriptor(key: "priority", ascending: false),
        NSSortDescriptor(key: "duration", ascending: true),
        NSSortDescriptor(key: "dueDate", ascending: true)
    ]
    static var requestAll: NSFetchRequest<TodoEntity> {
        let request = TodoEntity.fetchRequest()
        request.sortDescriptors = sortByListOrder
        return request
    }
    static var requestSorted: NSFetchRequest<TodoEntity> {
        let request = TodoEntity.fetchRequest()
        request.sortDescriptors = sortByAll
        return request
    }
    func setValue(todo: Todo) {
        self.id = todo.id
        self.text = todo.text
        self.isDone = todo.isDone
        self.listOrder = Int64(todo.listOrder)
        self.priority = Int32(todo.priority.rawValue)
        self.duration = Int32(todo.duration.rawValue)
        self.dueDate = todo.dueDate
        if let objectID = todo.category?.objectID {
            self.category = try? PersistenceController.shared.container.viewContext.existingObject(
                with: objectID
            ) as? CategoryEntity
            print("SetValue: Object ID found")
            if self.category != nil {
                print("category is not nil")
            }else{
                print("Category is nil")
            }
        }
    }
}
