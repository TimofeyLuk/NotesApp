//
//  NoteAppApp.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 16.05.22.
//

import SwiftUI

@main
struct NoteAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
