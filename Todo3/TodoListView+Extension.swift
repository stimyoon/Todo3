//
//  TodoListView+Extension.swift
//  Todo2
//
//  Created by Tim Yoon on 8/14/22.
//

import SwiftUI

extension TodoListView {
    func filteredTodoListView(filter: @escaping (Todo)->Bool)->some View{
        ForEach($vm.todos){ $todo in
            if filter(todo) {
                NavigationLink {
                    TodoDetailView(todo: todo) {
                        vm.update(todo: $0)
                    } deleteCompletion: { vm.delete(todo: $0)
                    }
                    .environmentObject(vm)
                    .environmentObject(categoryVM)
                } label: {
                    TodoCellView(todo: $todo)
                        .environmentObject(vm)
                }
                .buttonStyle(.plain)
            }
        }
        .onDelete(perform: vm.delete)
        .onMove(perform: vm.move)
    }
    
    var textFieldAddView : some View {
        HStack{
            TextField("Enter todo", text: $textFieldText)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    if textFieldText == "" {
                        hideKeyboard()
                    } else {
                        addNewTodoWithTextFieldText()
                    }
                }
            Button {
                addNewTodoWithTextFieldText()
            } label: {
                Text("Add")
            }
            .buttonStyle(.bordered)
        }.padding(.horizontal)
    }
    
    func addNewTodoWithTextFieldText(){
        withAnimation {
            var todo = Todo()
            todo.text = textFieldText
            vm.add(todo: todo)
            textFieldText = ""
        }
    }
}
