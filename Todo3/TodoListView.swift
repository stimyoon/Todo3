//
//  ContentView.swift
//  Todo2
//
//  Created by Tim Yoon on 8/8/22.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var vm: TodoListVM
    @EnvironmentObject var categoryVM: CategoryDataService
    @State var text = ""
    @State var isDone = false
    @State var showTodoDetailView = false
    @State var textFieldText = ""
    
    var body: some View {
        
            VStack{
                List{
                    Section(header: Text("todo list")) {
                        filteredTodoListView(filter: {!$0.isDone})
                    }
                    Section(header: Text("done list")){
                        filteredTodoListView(filter: {$0.isDone})
                    }
                }
                .listStyle(.plain)
                textFieldAddView
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            vm.toggleSort()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(vm.isSortedManually ? Color.gray : Color.accentColor)
                    }
                    
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack{
                        Button {
                            withAnimation {
                                vm.undo()
                            }
                        } label: {
                            Image(systemName: "arrow.uturn.backward")
                        }
                        .disabled(!(PersistenceController.shared.context.undoManager?.canUndo ?? false))
                        
                        Button {
                            withAnimation {
                                vm.redo()
                            }
                        } label: {
                            Image(systemName: "arrow.uturn.forward")
                        }
                        .disabled(!(PersistenceController.shared.context.undoManager?.canRedo ?? false))
                    }
                }
            }
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
}
struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TodoListView()
                .environmentObject(TodoListVM(dataservice: CoreDataDataService()))
                .environmentObject(CategoryDataService())
            .preferredColorScheme(.light)
        }
    }
}
