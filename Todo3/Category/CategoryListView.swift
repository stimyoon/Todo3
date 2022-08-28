//
//  CategoryListView.swift
//  Todo3
//
//  Created by Tim Yoon on 8/25/22.
//

import SwiftUI
struct CategoryDetailView: View {
    @State var category: Category
    var completion : (Category)->()

    var body: some View {
        Form{
            TextField("name", text: $category.name)
            ColorPickerView(selectedColor: $category.color)
            Button {
                completion(category)
            } label: {
                Text("Save")
            }

        }
    }
}
struct CategoryRowView: View {
    let category : Category
    var body: some View {
        HStack {
            Text("\(category.name)")
            Spacer()
            category.color.color
                .opacity(0.4)
                .frame(width: 30, height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
        }
    }
}
struct CategoryListView: View {
    @State var categoryName = ""
    @State var categoryColor = CategoryColor.clear
    @StateObject var vm = CategoryDataService()
    
    var body: some View {
        List{
            Section("Add") {
                TextField("Category Name", text: $categoryName)
                ColorPickerView(selectedColor: $categoryColor)
                Button {
                    addButtonAction()
                } label: {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            
            Section("List") {
                ForEach(vm.categories){ category in
                    NavigationLink {
                        CategoryDetailView(category: category) {  vm.update($0)
                        }
                    } label: {
                        CategoryRowView(category: category)
                    }
                }
                .onDelete(perform: vm.delete)
            }

    
        }
        .navigationTitle("Category List")
    }
}
extension CategoryListView {
    func addButtonAction(){
        var category = Category()
        category.name = categoryName
        category.color = categoryColor
        vm.add(category)
        categoryName = ""
    }
}
struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryListView()
        }
    }
}
