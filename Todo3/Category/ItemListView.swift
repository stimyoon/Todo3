//
//  ItemListView.swift
//  Todo3
//
//  Created by Tim Yoon on 8/26/22.
//

import SwiftUI

import Foundation

protocol Listable: AnyObject {
    associatedtype ItemType: Identifiable
    var items : [ItemType] { set get }
    func add(_ item: ItemType)
    func delete(_ item: ItemType)
    func delete(indexSet: IndexSet)
    func update(_ item: ItemType)
    func move(at offsets: IndexSet, to offset: Int)
}
extension Listable {
    func add(_ item: ItemType){
        items.append(item)
    }
    func delete(_ item: ItemType){
        guard let index = items.firstIndex(where: {$0.id == item.id}) else { return }
        items.remove(at: index)
    }
    func delete(indexSet: IndexSet){
        guard let index = indexSet.first else { return }
        guard index > 0 && index < items.count else { return }
        items.remove(at: index)
    }
    func update(_ item: ItemType){
        guard let index = items.firstIndex(where: {$0.id == item.id})
        else {
            return
        }
        items[index] = item
    }
    func move(at offsets: IndexSet, to offset: Int) {
        items.move(fromOffsets: offsets, toOffset: offset)
    }
}

protocol DataService: ObservableObject{
    associatedtype ItemType: Equatable
    associatedtype ItemEntityType: Equatable
    
    var items: [ItemType] {get set }
    var itemEntities: [ItemEntityType] { get set }
    
    func add(_ item: ItemType)
    func delete(_ item: ItemType)
    func update(_ item: ItemType)
}
extension DataService {
    func add(_ item: ItemType){
        items.append(item)
    }
    func delete(_ item: ItemType){
        guard let index = items.firstIndex(where: {$0 == item}) else { return }
        items.remove(at: index)
    }
    func update(_ item: ItemType){
        guard let index = items.firstIndex(where: {$0 == item}) else { return }
        items[index] = item
    }
}
class ListObject<T: Identifiable>{
    @Published private (set) var items : [T] = []
    func add(_ item: T){
        items.append(item)
    }
    func delete(_ item: T){
        guard let index = items.firstIndex(where: {$0.id == item.id}) else { return }
        items.remove(at: index)
    }
    func delete(indexSet: IndexSet){
        guard let index = indexSet.first else { return }
        guard index > 0 && index < items.count else { return }
        items.remove(at: index)
    }
    func update(_ item: T){
        guard let index = items.firstIndex(where: {$0.id == item.id})
        else {
            return
        }
        items[index] = item
    }
    func move(at offsets: IndexSet, to offset: Int) {
        items.move(fromOffsets: offsets, toOffset: offset)
    }
}
struct MyString: Identifiable {
    var id = UUID()
    var name = ""
}
class ItemVM: ListObject<MyString>, ObservableObject {
    override func add(_ item: MyString) {
        super.add(item)
    }
}
struct ItemListView: View {
    @ObservedObject var vm : ItemVM
    @State var name : String = ""
    var body: some View {
        List{
            TextField("name", text: $name)
            Button {
                vm.add(MyString(name: name))
            } label: {
                Text("Add")
            }

            ForEach(vm.items){ item in
                Text("\(item.name)")
            }
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(vm: ItemVM())
    }
}
