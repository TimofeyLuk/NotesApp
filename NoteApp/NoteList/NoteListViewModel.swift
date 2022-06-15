//
//  NoteListViewModel.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 19.05.22.
//

import SwiftUI
import CoreData

final class NoteListViewModel {
    
    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext ) {
        viewContext = context
    }
 
    var newNoteViewModel: NoteEditorViewModel {
        return NoteEditorViewModel(context: viewContext, note: nil)
    }
    
    func deleteNote(_ note: Note) {
        viewContext.delete(note)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func editViewModel(forNote note: Note) -> NoteEditorViewModel {
        NoteEditorViewModel(context: viewContext, note: note)
    }
}
