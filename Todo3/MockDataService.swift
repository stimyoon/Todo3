//
//  DataService.swift
//  Todo2
//
//  Created by Tim Yoon on 8/8/22.
//

import Foundation
import Combine

class MockDataService: DataServiceProtocol {
    func getCanUndoStatus() -> AnyPublisher<Bool, Error> {
        $canUndo.tryMap({$0}).eraseToAnyPublisher()
    }
    
    func getCanRedoStatus() -> AnyPublisher<Bool, Error> {
        $canRedo.tryMap({$0}).eraseToAnyPublisher()
    }
    
    @Published var items : [Todo] = []
    @Published var canUndo = false
    @Published var canRedo = false
    
    func get() -> AnyPublisher<[Todo], Error> {
        $items.tryMap({$0}).eraseToAnyPublisher()
    }
    
    func add(_ item: Todo) {
        items.append(item)
    }
    func delete(_ item: Todo) {
        guard let index = items.firstIndex(where: { $0.id == item.id
        }) else { return }
        items.remove(at: index)
    }
    
    func update(_ item: Todo) {
        guard let index = items.firstIndex(where: { $0.id == item.id
        }) else { return }
        items[index] = item
    }
    func setListOrder() {
        guard items.count > 0 else { return }
        for index in 0..<items.count {
            items[index].listOrder = items.count - 1 - index
        }
    }
    
    init(){
    }
}

