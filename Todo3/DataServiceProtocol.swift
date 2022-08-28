//
//  DataServiceProtocol.swift
//  Todo2
//
//  Created by Tim Yoon on 8/8/22.
//

import Foundation
import Combine

protocol DataServiceProtocol {
    func get()->AnyPublisher<[Todo], Error>
    func getCanUndoStatus()->AnyPublisher<Bool, Error>
    func getCanRedoStatus()->AnyPublisher<Bool, Error>
    
    func add(_ item: Todo)
    func delete(_ item: Todo)
    func update(_ item: Todo)
    func undo()
    func redo()
    func setListOrder()
    func beginUndoGrouping()
    func endUndoGrouping()
    func move(at offsets: IndexSet, to index: Int)
    func toggleSort()
    func canUndo()->Bool
    func canRedo()->Bool
}
extension DataServiceProtocol {
    func move(at offsets: IndexSet, to index: Int){}
    func undo(){}
    func redo(){}
    func beginUndoGrouping(){}
    func endUndoGrouping(){}
    func toggleSort(){}
    func canUndo()->Bool{return false}
    func canRedo()->Bool{return false}
}
