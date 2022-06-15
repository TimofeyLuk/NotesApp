//
//  NoteListCell.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 18.05.22.
//

import SwiftUI

struct NoteListCell: View {
    @ObservedObject var note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .lineLimit(1)
            HStack {
                let date = note.timestamp ?? Date()
                Text( date, formatter: itemFormatter(forDate: date))
            }
        }
    }
    
    private func itemFormatter(forDate date: Date) -> DateFormatter {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        formatter.timeStyle = .short
        if !calendar.isDateInToday(date) {
            formatter.dateStyle = .medium
        }
        return formatter
    }
}

struct NoteListCell_Previews: PreviewProvider {
    static var previews: some View {
        let note = Note(context: PersistenceController.preview.container.viewContext)
        note.timestamp = Date()
        note.text = NSMutableAttributedString(string: "Test note")
        return NoteListCell(note: note)
    }
}
