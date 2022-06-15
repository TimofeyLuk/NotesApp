//
//  NoteListView.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 16.05.22.
//

import SwiftUI
import CoreData

struct NoteListView: View {

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)],
        animation: .default
    )
    private var notes: FetchedResults<Note>
    let viewModel: NoteListViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(notes) { note in
                    NavigationLink {
                        NoteEditorView(
                            viewModel: viewModel.editViewModel(forNote: note)
                        )
                    } label: {
                        NoteListCell(note: note)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    NavigationLink {
                        NoteEditorView(
                            viewModel: viewModel.newNoteViewModel
                        )
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }

                }
            }
            .navigationTitle("Notes".localized)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { notes[$0] }.forEach { viewModel.deleteNote($0) }
        }
    }

}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView(
            viewModel: NoteListViewModel(
                context: PersistenceController.preview.container.viewContext
            )
        )
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
