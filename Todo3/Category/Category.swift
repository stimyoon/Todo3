//
//  Category.swift
//  Todo3
//
//  Created by Tim Yoon on 8/25/22.
//

import Foundation
import CoreData

struct Category: Identifiable, Hashable {
    var id = UUID()
    var objectID: NSManagedObjectID?
    var color : CategoryColor = CategoryColor.clear
    var name: String = ""
}
extension Category {
    init(entity: CategoryEntity){
        self.id = entity.id ?? UUID()
        self.objectID = entity.objectID
        self.color = CategoryColor(rawValue: Int(entity.color)) ?? CategoryColor.clear
        self.name = entity.name ?? ""
    }
}

extension CategoryEntity {
    func setValue(category: Category) {
        self.id = category.id
        self.color = Int64(category.color.rawValue)
        self.name = category.name
    }
}
