//
//  CoreDataDataService.swift
//  Todo2
//
//  Created by Tim Yoon on 8/8/22.
//

import Foundation
import Combine
import CoreData


class CoreDataDataService: NSObject, ObservableObject, DataServiceProtocol {
    @Published private (set) var todos : [Todo] = []
    @Published private var todoEntities : [TodoEntity] = []
    @Published private (set) var isSorted = false
    @Published private (set) var canUndo = false
    @Published private (set) var canRedo = false

    let manager = PersistenceController.shared
    private var cancellables = Set<AnyCancellable>()
    private var fetchedResultsController: NSFetchedResultsController<TodoEntity>
    private var fetchRequest = TodoEntity.requestAll
    
    func toggleSort() {
        setListOrder()
        isSorted.toggle()
        fetch()
    }
    override init() {
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manager.context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            guard let entities = fetchedResultsController.fetchedObjects else { return }
            self.todoEntities = entities
        } catch {
            print(error)
        }
        self.canUndo = manager.context.undoManager?.canUndo ?? false
        self.canRedo = manager.context.undoManager?.canRedo ?? false
        
        fetch()
        $todoEntities
            .map { entities in
                entities.map { (entity: TodoEntity) -> Todo in
                    return Todo(entity)
                }
            }
            .sink { error in
                fatalError("\(error)")
            } receiveValue: { [weak self] todos in
                self?.todos = todos
            }
            .store(in: &cancellables)
        

    }
    
    
    private func fetch(){
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        request.sortDescriptors = isSorted ? TodoEntity.sortByAll : TodoEntity.sortByListOrder
        
        do {
            todoEntities = try manager.context.fetch(request)
        } catch let error {
            fatalError("Error: Unable to fetch coredata \(error.localizedDescription)")
        }
    }
    
    func get() -> AnyPublisher<[Todo], Error> {
        $todos.tryMap( {$0} ).eraseToAnyPublisher()
    }
    func getCanUndoStatus() -> AnyPublisher<Bool, Error> {
        $canUndo.tryMap({$0}).eraseToAnyPublisher()
    }
    
    func getCanRedoStatus() -> AnyPublisher<Bool, Error> {
        $canRedo.tryMap( {$0} ).eraseToAnyPublisher()
    }

    func getById(id: UUID) -> TodoEntity? {
        guard let todoEntity = todoEntities.first(where: {$0.id == id})
        else {
            print("unable to getById")
            return nil
        }
        return todoEntity
    }
    
    func add(_ todo: Todo) {
        let entity = TodoEntity(context: manager.context)
        entity.setValue(todo: todo)
        entity.listOrder = Int64(todos.count+1)
        manager.save()
        fetch()
    }
    func move(at offsets: IndexSet, to index: Int) {
        todoEntities.move(fromOffsets: offsets, toOffset: index)
        isSorted = false
        setListOrder()
    }
    func setListOrder() {
        manager.beginUndoGrouping()
        for index in 0..<todoEntities.count {
            todoEntities[index].listOrder = Int64(todoEntities.count - index)
        }
        manager.save()
        manager.endUndoGrouping()
    }
    func delete(_ todo: Todo) {
        guard let index = todoEntities.firstIndex(where: {$0.id == todo.id}) else { return }
        manager.context.delete(todoEntities[index])
        manager.save()
        fetch()
    }
    
    func update(_ todo: Todo) {
        guard let index = todoEntities.firstIndex(where: {$0.id == todo.id}) else { return }
        let entity = todoEntities[index]
        entity.setValue(todo: todo)
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

extension CoreDataDataService: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let entities = controller.fetchedObjects as? [TodoEntity] else { return }
        self.todoEntities = entities
    }
}
