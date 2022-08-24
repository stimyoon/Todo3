//
//  Todo3App.swift
//  Todo3
//
//  Created by Tim Yoon on 8/23/22.
//

import SwiftUI

@main
struct Todo3App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
