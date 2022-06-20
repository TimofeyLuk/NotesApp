//
//  NoteEditorView.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 19.05.22.
//

import SwiftUI

struct NoteEditorView: View {
    
    @StateObject var viewModel: NoteEditorViewModel
    
    var body: some View {
        VStack {
            viewModel.makeTextField()
            NoteEditorToolBar(viewModel: viewModel)
        }
        .onDisappear {
            viewModel.saveNote()
        }
    }
}

struct NoteEditorView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let note = Note(context: context)
        note.timestamp = Date()
        note.text = NSMutableAttributedString(
            string: String.randomString(length: 20)
        )
        let viewModel = NoteEditorViewModel(
            context: context,
            note: note
        )
        return NoteEditorView(viewModel: viewModel)
    }
}
