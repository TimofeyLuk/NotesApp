//
//  AttributedTextField.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 1.06.22.
//

import SwiftUI

struct AttributedTextField: View {
    
    var viewModel: AttributedTextFieldViewModel
    
    var body: some View {
        viewModel.makeAttributedTextFieldWrapper()
    }
}

struct AttributedTextField_Previews: PreviewProvider {
    static var previews: some View {
        AttributedTextField(
            viewModel: AttributedTextFieldViewModel(
                attributedText: NSMutableAttributedString(string: "String")
            )
        )
    }
}
