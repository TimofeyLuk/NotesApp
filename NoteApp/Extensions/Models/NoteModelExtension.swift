//
//  NoteModelExtension.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 18.05.22.
//

import Foundation

extension Note {
    var title: AttributedString {
        guard
            let firstLine = text?.string.split(whereSeparator: \.isNewline).first
        else { return AttributedString("Empty note".localized) }
        return AttributedString(firstLine)
    }
}
