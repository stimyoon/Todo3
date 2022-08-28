//
//  TodoListVM.swift
//  Todo2
//
//  Created by Tim Yoon on 8/8/22.
//

import Foundation
import Combine

class TodoListVM: ObservableObject {
    @Published var todos = [Todo]()
    @Published var isSortedManually = true
    @Published var canUndo: Bool = false
    @Published var canRedo: Bool = false
    
    private var cancellables = Set<AnyCancellable>()

    let dataservice : DataServiceProtocol
    init(dataservice: DataServiceProtocol){
        self.dataservice = dataservice
        dataservice.get()
            .sink { error in
                fatalError("\(error)")
            } receiveValue: { [weak self] items in
                self?.todos = items
            }
            .store(in: &cancellables)
        
        dataservice.getCanUndoStatus()
            .sink { error in
                fatalError("\(error)")
            } receiveValue: { [weak self] canUndoStatus in
                self?.canUndo = canUndoStatus
            }
            .store(in: &cancellables)
        
        dataservice.getCanRedoStatus()
            .sink { error in
                fatalError("\(error)")
            } receiveValue: { [weak self] canRedoStatus in
                self?.canRedo = canRedoStatus
            }
            .store(in: &cancellables)

        
    }
    func toggleSort(){
        isSortedManually.toggle()
        dataservice.toggleSort()
    }
//    func setListOrder(){
//        dataservice.setListOrder()
//    }
    
    // Checks to make sure that we are not adding a todo with a pre-existing id
    // If it is a new todo, it adds it and uses the inout to change the todo to a new
    // todo. This is mainly for the iPad because the detail view does not disappear
    // like it does on an iPhone.
    func add(todo: Todo){
        let index = todos.firstIndex { $0.id == todo.id }
        if index == nil {
            dataservice.add(todo)
        }
    }
    func move(at offsets: IndexSet, to index: Int){
        dataservice.move(at: offsets, to: index)
    }
    
    func delete(todo: Todo){
        dataservice.delete(todo)
    }
    func delete(indexSet: IndexSet){
        guard let index = indexSet.first else { return }
        delete(todo: todos[index])
    }
    func update(todo: Todo){
        dataservice.update(todo)
    }
    func undo(){
        dataservice.undo()
    }
    func redo(){
        dataservice.redo()
    }
}
