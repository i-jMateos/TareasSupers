//
//  TodoListJordiApp.swift
//  TodoListJordi
//
//  Created by Jordi Mateos on 23/11/22.
//

import SwiftUI

@main
struct TodoListJordiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Principal()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
