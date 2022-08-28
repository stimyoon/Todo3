//
//  Models.swift
//  Todo2
//
//  Created by Tim Yoon on 8/8/22.
//

import SwiftUI

enum Duration: Int, CaseIterable, Identifiable {
    case short = 0, medium, long
    var text: String {
        switch self {
        case .short:
            return "short"
        case .medium:
            return "medium"
        case .long:
            return "long"
        }
    }
    var id : Self{ self }
}
enum Priority: Int, CaseIterable, Identifiable {
    case low = 0, medium, high
    var text: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Med"
        case .high:
            return "High"
        }
    }
    var id : Self{ self }
}

struct Todo : Identifiable, Equatable {
    var id = UUID()
    var text = ""
    var isDone = false
    var priority = Priority.low
    var duration = Duration.short
    var dueDate = Date()
    var listOrder = 0
    var category : Category?
}
extension Todo {
    mutating func setValue(_ entity: TodoEntity){
        self.isDone = entity.isDone
        self.text = entity.text ?? ""
        self.id = entity.id ?? UUID()
        self.dueDate = entity.dueDate ?? Date()
        self.priority = Priority(rawValue: Int(entity.priority)) ?? Priority.low
        self.duration = Duration(rawValue: Int(entity.duration)) ?? Duration.short
        self.listOrder = Int(entity.listOrder)
        if let categoryEntity = entity.category {
            self.category = Category(entity: categoryEntity)
        } else {
            self.category = nil
        }
    }
    init(_ entity: TodoEntity){
        setValue(entity)
    }
}
