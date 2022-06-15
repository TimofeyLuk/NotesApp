//
//  NoteApp.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 16.05.22.
//

import SwiftUI

@main
struct NoteApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let viewContext = persistenceController.container.viewContext
            let noteListViewModel = NoteListViewModel(context: viewContext)
            NoteListView(viewModel: noteListViewModel)
                .environment(\.managedObjectContext, viewContext)
        }
    }
}
