//
//  CategoryPickerView.swift
//  Todo3
//
//  Created by Tim Yoon on 8/25/22.
//

import SwiftUI

struct CategoryPickerView: View {
    @Binding var category : Category
    @EnvironmentObject var vm : CategoryDataService
    var body: some View {
        if vm.categories.isEmpty {
            NavigationLink {
                CategoryListView()
            } label: {
                VStack{
                    Text("There no categories")
                    Text("Create categories")
                }
            }
        }else{
            HStack {
//                Text("\(category.name)")
                Picker("Category", selection: $category) {
                    ForEach(vm.categories){ category in
                        CategoryRowView(category: category).tag(category)
                    }
                }
            }
        }
    }
}

struct CategoryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            CategoryPickerView(category: .constant(Category(color: CategoryColor.teal, name: "Work")))
                .environmentObject(CategoryDataService())
        }
    }
}
