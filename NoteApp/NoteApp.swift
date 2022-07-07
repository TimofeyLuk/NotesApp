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
            let noteListViewModel = NoteListViewModel()
            NoteListView(viewModel: noteListViewModel)
        }
    }
}

