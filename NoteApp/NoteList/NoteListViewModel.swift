//
//  NoteListViewModel.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 19.05.22.
//

import SwiftUI
import CoreData
import Combine

final class NoteListViewModel: ObservableObject {
    private let database = Database.shared
    private var cancellables = Set<AnyCancellable>()
    @Published var notes: [Note] = []

    init() {
        database.$notes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notes in
                self?.notes = notes
            }
            .store(in: &cancellables)
    }
 
    var newNoteViewModel: NoteEditorViewModel {
        return NoteEditorViewModel(note: nil)
    }
    
    func deleteNote(_ note: Note) {
        database.deleteNote(note)
    }
    
    func editViewModel(forNote note: Note) -> NoteEditorViewModel {
        NoteEditorViewModel(note: note)
    }
}
