//
//  DataService.swift
//  Todo3
//
//  Created by Tim Yoon on 8/25/22.
//

import Foundation
import CoreData
import Combine

protocol CoreDataService: NSObject, ObservableObject {
    associatedtype Item : Identifiable
    associatedtype ItemEntity : NSManagedObject
    var items: [Item] { get set }
    var itemEntities: [ItemEntity] { get set }
    func get()->AnyPublisher<[Item], Error>
    
    var cancellables: Set<AnyCancellable> { get set }
    var fetchedResultsController: NSFetchedResultsController<TodoEntity> { get set }
    var fetchRequest : NSFetchRequest<ItemEntity> { get set }
    
    
    func add(_ item: Item)
    func delete(_ item: Item)
    func update(_ item: Item)
    func move(at offsets: IndexSet, to index: Int)
}
extension CoreDataService {
    func move(at offsets: IndexSet, to index: Int){}
}
