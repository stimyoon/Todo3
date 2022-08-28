//
//  TodoDetailView.swift
//  Todo2
//
//  Created by Tim Yoon on 8/8/22.
//

import SwiftUI

struct TodoDetailView: View {
    @EnvironmentObject var categoryVM: CategoryDataService
    @EnvironmentObject var vm: TodoListVM
    @State var todo : Todo
    var saveCompletion: (Todo)->()
    var deleteCompletion: (Todo)->()
    @FocusState var isTextFieldFocused: Bool
    @Environment(\.dismiss) var dismiss
    @State var category = Category()

    var body: some View {
        Form{
            Section("Todo item"){
                TextField("enter a todo item", text: $todo.text)
                    .focused($isTextFieldFocused)
            }
            Section("Done"){
                Picker("isDone", selection: $todo.isDone) {
                        Text("Done").tag(true)
                        Text("Not Done").tag(false)
                }.pickerStyle(.segmented)
            }
            Section("Category"){
                if !categoryVM.categories.isEmpty {
                    HStack{
                        CategoryCellView(category: category)
                        CategoryPickerView(category: $category)
                            .onChange(of: category) { newValue in
                                todo.category = category
                            }
                    }
                }
                NavigationLink {
                    CategoryListView()
                } label: {
                    Text("Manage Category List")
                }
            }
            
            Section("Priority"){
                Picker("Priority", selection: $todo.priority) {
                    ForEach(Priority.allCases){ priority in
                        Text("\(priority.text)")
                    }
                }
                .pickerStyle(.segmented)
            }
            Section("Duration"){
                Picker("Duration", selection: $todo.duration) {
                    ForEach(Duration.allCases){ duration in
                        Text("\(duration.text)")
                    }
                }
                .pickerStyle(.segmented)
            }
            Section("Due Date"){
                DatePicker("Due Date", selection: $todo.dueDate)
            }

            HStack{
                Button(role: .destructive) {
                    deleteCompletion(todo)
                    dismiss()
                } label: {
                    Text("Delete")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                Button {
                    saveCompletion(todo)
                    todo = Todo()
                    dismiss()
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Edit View")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    saveCompletion(todo)
                    todo = Todo()
                    dismiss()
                } label: {
                    Text("Save")
                }

            }
        }
        .onAppear {
            if todo.category == nil {
                if !categoryVM.categories.isEmpty {
                    category = categoryVM.categories[0]
                    todo.category = category
                }else{
                    categoryVM.add(Category(color: CategoryColor.accent, name: "Work"))
                    category = categoryVM.categories[0]
                    todo.category = category
                }
            }
        }
    }
    init(todo: Todo, saveCompletion: @escaping (Todo)->(), deleteCompletion: @escaping (Todo)->()){
        _todo = State(initialValue: todo)
        self.saveCompletion = saveCompletion
        self.deleteCompletion = deleteCompletion
        if let category = todo.category {
            _category = State(initialValue: category)
        }
    }
}

struct TodoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = TodoListVM(dataservice: CoreDataDataService())
        let todo = Todo(id: UUID(), text: "Wash car", isDone: true, priority: .high, duration: .long, dueDate: Date(), listOrder: 0)
        
        NavigationView {
            TodoDetailView(todo: todo,
                           saveCompletion: { todo in
                vm.add(todo: todo)},
                           deleteCompletion: { todo in
                vm.delete(todo: todo)
            })
            .environmentObject(CategoryDataService())
        }
//        .preferredColorScheme(.dark)
    }
}
