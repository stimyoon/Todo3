//
//  Todo3App.swift
//  Todo3
//
//  Created by Tim Yoon on 8/23/22.
//

import SwiftUI

@main
struct Todo3App: App {
    @StateObject var vm = TodoListVM(dataservice: CoreDataDataService())
    @StateObject var categoryVM = CategoryDataService()
    var body: some Scene {
        WindowGroup {
            NavigationView{
                TodoListView()
                    .environmentObject(vm)
                    .environmentObject(categoryVM)
            }
        }
    }
}
