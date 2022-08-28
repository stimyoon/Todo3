//
//  TodoCellView.swift
//  Todo2
//
//  Created by Tim Yoon on 8/9/22.
//

import SwiftUI

struct TodoCellView: View {
    @EnvironmentObject var vm: TodoListVM
    @Binding var todo : Todo
    @State private var showDetailView = false
    
    var body: some View {
        HStack(spacing: 0){
            Image(systemName: isDoneImageName)
                .resizable()
                .frame(maxHeight: 25)
                .frame(maxWidth: 25)
                .foregroundColor(isDoneImageColor)
                .padding(.trailing)
                .onTapGesture {
                    withAnimation {
                        todo.isDone.toggle()
                        vm.update(todo: todo)
                        
                    }
                }
                TextField("enter text",text: $todo.text)
                    .onSubmit {
                        withAnimation {
                            vm.update(todo: todo)
                        }
                    }
              
                Spacer()
                if todo.category != nil {
                        CategoryCellView(category: todo.category!)
                        .overlay(
                            HStack{
                                PriorityView(todo: todo)
                                DurationView(todo: todo)
                            }
                        )
                }else{
                    HStack{
                        PriorityView(todo: todo)
                        DurationView(todo: todo)
                    }
                }
        }
    }
    private var isDoneImageName : String {
        todo.isDone ? "checkmark.circle" : "circle"
    }
    private var isDoneImageColor : Color {
        todo.isDone ? Color.green : Color.accentColor
    }
    private var dueDateString : String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: todo.dueDate)
    }
}

struct TodoCellView_Previews: PreviewProvider {
    static var previews: some View {
        TodoCellView(todo: .constant(Todo(text: "Wash the car", isDone: true, category: Category(color: CategoryColor.teal, name: "Work"))))
            .previewLayout(.sizeThatFits)
        TodoCellView(todo: .constant(Todo(text: "Wash the car", isDone: false)))
            .previewLayout(.sizeThatFits)
    }
}
