//
//  NoteEditorToolBar.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 6.06.22.
//

import SwiftUI

struct NoteEditorToolBar: View {
    
    var viewModel: NoteEditorViewModel
    @State private var fontSize = UIFont.systemFontSize
    @State private var isImagePickerShown = false
    
    var body: some View {
        VStack {
            HStack {
                fontAttributsMenu
                Spacer()
                Button(
                    action: { isImagePickerShown = true },
                    label: { Image(systemName: "photo") }
                )
                Spacer()
                textAligmentMenu
            }
            fontSizeEditor
        }
        .foregroundColor(.black)
        .sheet(isPresented: $isImagePickerShown) {
            ImagePicker(selectedImage: .constant(nil),
                        onSelectImage: { image, _ in
                viewModel.insertImage(image)
            })
        }
    }
    
    private var fontAttributsMenu: some View {
        HStack {
            Button(
                action: { viewModel.makeTextBold() },
                label: { Text("B").fontWeight(.bold) }
            )
            Button(
                action: { viewModel.makeTextItalic() },
                label: { Text("I").italic()  }
            )
            .padding()
            Button(
                action: { viewModel.makeTextStrike() },
                label: { Text("S").strikethrough() }
            )
        }
        .font(.body)
        .padding(.horizontal)
    }
    
    private var textAligmentMenu: some View {
        HStack(spacing: 15) {
            Button(
                action: { viewModel.setTextAlign(align: .left) },
                label: { Image(systemName: "text.alignleft") }
            )
            Button(
                action: { viewModel.setTextAlign(align: .center) },
                label: { Image(systemName: "text.aligncenter") }
            )
            Button(
                action: { viewModel.setTextAlign(align: .right) },
                label: { Image(systemName: "text.alignright") }
            )
        }
        .font(.body)
        .padding()
    }
    
    private var fontSizeEditor: some View {
        let minFontSize = UIFont.systemFontSize
        let maxFontSize = UIFont.systemFontSize * 2
        return VStack {
            Text("\(Int(fontSize))")
            HStack {
                Text("A")
                    .font(.system(size: minFontSize))
                    .onTapGesture {
                        fontSize = minFontSize
                        viewModel.setFontSize(minFontSize)
                    }
                Slider(
                    value: $fontSize,
                    in: minFontSize...maxFontSize,
                    step: 1) { _ in
                        viewModel.setFontSize(fontSize)
                    }
                Text("A")
                    .font(.system(size: maxFontSize))
                    .onTapGesture {
                        fontSize = maxFontSize
                        viewModel.setFontSize(maxFontSize)
                    }
            }
        }
        .padding(.horizontal)
    }
}

struct NoteEditorToolBar_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let note = Note(context: context)
        note.timestamp = Date()
        note.text = NSMutableAttributedString(
            string: String.randomString(length: 20)
        )
        let viewModel = NoteEditorViewModel(
            note: note
        )
        return NoteEditorToolBar(viewModel: viewModel)
    }
}
