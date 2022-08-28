//
//  CategoryDataService.swift
//  Todo3
//
//  Created by Tim Yoon on 8/25/22.
//

import Foundation
import Combine
import CoreData

class CategoryDataService: NSObject, ObservableObject{
    typealias ItemType = Category
    @Published private (set) var categories : [Category] = []
    @Published private var categoryEntities : [CategoryEntity] = []
    
    let manager = PersistenceController.shared
    private var cancellables = Set<AnyCancellable>()
    private var fetchedResultsController: NSFetchedResultsController<CategoryEntity>
    private var fetchRequest = requestAll
    static let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    static var requestAll: NSFetchRequest<CategoryEntity> {
        let request = CategoryEntity.fetchRequest()
        request.sortDescriptors = sortDescriptors
        return request
    }
    
    override init() {
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manager.context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            guard let entities = fetchedResultsController.fetchedObjects else { return }
            self.categoryEntities = entities
        } catch {
            print(error)
        }
        
        fetch()
        $categoryEntities
            .map { entities in
                entities.map { (entity: CategoryEntity) -> Category in
                    return Category(entity: entity)
                }
            }
            .sink { error in
                fatalError("\(error)")
            } receiveValue: { [weak self] categories in
                self?.categories = categories
            }
            .store(in: &cancellables)
    }
    
    
    private func fetch(){
        let request = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
        request.sortDescriptors = CategoryDataService.sortDescriptors
        
        do {
            categoryEntities = try manager.context.fetch(request)
        } catch let error {
            fatalError("Error: Unable to fetch coredata \(error.localizedDescription)")
        }
    }
    
    func get() -> AnyPublisher<[Category], Error> {
        $categories.tryMap( {$0} ).eraseToAnyPublisher()
    }

//    func getById(id: UUID) -> TodoEntity? {
//        guard let todoEntity = todoEntities.first(where: {$0.id == id})
//        else {
//            print("unable to getById")
//            return nil
//        }
//        return todoEntity
//    }
    
    func add(_ category: Category) {
        let entity = CategoryEntity(context: manager.context)
        entity.setValue(category: category)
        manager.save()
        fetch()
    }
//    func move(at offsets: IndexSet, to index: Int) {
//        categoryEntities.move(fromOffsets: offsets, toOffset: index)
//        setListOrder()
//    }
//    func setListOrder() {
//        manager.beginUndoGrouping()
//        for index in 0..<categoryEntities.count {
//            categoryEntities[index].listOrder = Int64(todoEntities.count - index)
//        }
//        manager.save()
//        manager.endUndoGrouping()
//    }
    func delete(_ category: Category) {
        guard let index = categoryEntities.firstIndex(where: {$0.id == category.id}) else { return }
        manager.context.delete(categoryEntities[index])
        manager.save()
        fetch()
    }

    func delete(indexSet: IndexSet){
        guard let index = indexSet.first else { return }
        delete(categories[index])
    }
    
    func update(_ category: Category) {
        guard let index = categoryEntities.firstIndex(where: {$0.id == category.id}) else { return }
        let entity = categoryEntities[index]
        entity.setValue(category: category)
        manager.save()
        fetch()
    }

    func undo() {
        manager.undo()
    }
    func redo() {
        manager.redo()
    }
}


extension CategoryDataService: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let entities = controller.fetchedObjects as? [CategoryEntity] else { return }
        self.categoryEntities = entities
    }
}
