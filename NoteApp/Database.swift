//
//  Database.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 24.06.22.
//

import CoreData
import Combine

final class Database: ObservableObject {
    
    static let shared = Database()
    
    @Published private(set) var notes: [Note] = []
    private var container: NSPersistentContainer
    
    init() {
        self.container = NSPersistentContainer(name: "NoteApp")
        container.loadPersistentStores { [weak self] description, error in
            if let error = error {
                print("Core data loding was failed with error: \(error)")
            } else {
                print("Core data was loaded succssfuly")
                self?.fetchNotesList()
            }
        }
    }
    
    private func fetchNotesList() {
        let reqest = NSFetchRequest<Note>(entityName: "Note")
        reqest.sortDescriptors = [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)]
        do {
            let savedNotes = try container.viewContext.fetch(reqest)
            notes = savedNotes
        } catch (let error){
            print("Fetch notes error: \(error)")
        }
    }
    
    func createNote() -> Note {
        let note = Note(context: container.viewContext)
        note.timestamp = Date()
        saveData()
        return note
    }
    
    func saveNote(_ note: Note, text: NSMutableAttributedString) {
        note.text = text
        note.timestamp = Date()
        saveData()
    }
    
    func deleteNote(_ note: Note) {
        container.viewContext.delete(note)
        saveData()
    }
    
    private func saveData() {
        do {
            try container.viewContext.save()
            fetchNotesList()
        } catch(let error) {
            print("Save Core Data context error: \(error)")
        }
    }
}
