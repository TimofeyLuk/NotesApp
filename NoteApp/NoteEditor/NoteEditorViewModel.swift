//
//  NoteEditorViewModel.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 19.05.22.
//

import SwiftUI
import CoreData

final class NoteEditorViewModel: ObservableObject {

    private let viewContext: NSManagedObjectContext
    private(set) var noteRichText = NSMutableAttributedString()
    private let note: Note?
    private(set) var attributedTextFieldViewModel: AttributedTextFieldViewModel
    
    init(context: NSManagedObjectContext, note: Note?) {
        self.viewContext = context
        self.note = note
        if let noteText = note?.text as? NSMutableAttributedString {
            noteRichText = noteText.mutableCopy() as! NSMutableAttributedString
        }
        attributedTextFieldViewModel = AttributedTextFieldViewModel(attributedText: noteRichText)
    }

    func saveNote() {
        let  noteForSave = note ?? Note(context: viewContext)
        noteForSave.text = noteRichText
        noteForSave.timestamp = Date()
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func makeTextField() -> AttributedTextField {
        AttributedTextField(viewModel: attributedTextFieldViewModel)
    }
    
    func makeTextBold() {
        attributedTextFieldViewModel.makeTextBold()
    }
    
    func makeTextUnderline() {
        attributedTextFieldViewModel.makeTextUnderline()
    }
    
    func makeTextItalic() {
        attributedTextFieldViewModel.makeTextItalic()
    }
    
    func makeTextStrike() {
        attributedTextFieldViewModel.makeTextStrike()
    }
    
    func setTextAlign(align: NSTextAlignment) {
        attributedTextFieldViewModel.setTextAlign(align: align)
    }
    
    func setFontSize(_ size: CGFloat) {
        attributedTextFieldViewModel.setFontSize(size)
    }
    
    func insertImage(_ image: UIImage) {
        attributedTextFieldViewModel.insetImage(image)
    }
}
