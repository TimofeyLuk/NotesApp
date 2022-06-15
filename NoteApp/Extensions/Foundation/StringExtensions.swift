//
//  StringExtensions.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 18.05.22.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789          \n\n\t"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
