//
//  AttributedTextFieldViewModel.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 6.06.22.
//

import SwiftUI

final class AttributedTextFieldViewModel {
    
    var attributedText: NSMutableAttributedString
    private var textFieldCoordinator: ( () -> AttributedTextFieldWrapper.Coordinator )?
    
    init(attributedText: NSMutableAttributedString) {
        self.attributedText = attributedText
    }
    
    func makeAttributedTextFieldWrapper() -> AttributedTextFieldWrapper {
        let wrapper = AttributedTextFieldWrapper(attributedText: attributedText)
        textFieldCoordinator = { wrapper.getCoordinator() }
        return wrapper
    }
    
    func makeTextBold() {
        textFieldCoordinator?().makeTextBold()
    }
    
    func makeTextUnderline() {
        textFieldCoordinator?().makeTextUnderline()
    }
    
    func makeTextItalic() {
        textFieldCoordinator?().makeTextItalic()
    }
    
    func makeTextStrike() {
        textFieldCoordinator?().makeTextStrike()
    }
    
    func setTextAlign(align: NSTextAlignment) {
        textFieldCoordinator?().setTextAlign(align: align)
    }
    
    func setFontSize(_ size: CGFloat) {
        textFieldCoordinator?().setFontSize(size)
    }
    
    func insetImage(_ image: UIImage) {
        textFieldCoordinator?().insetImage(image)
    }
}
