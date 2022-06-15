//
//  AttributedTextFieldWrapper.swift
//  NoteApp
//
//  Created by Тимофей Лукашевич on 1.06.22.
//

import SwiftUI

final class AttributedTextFieldWrapper: UIViewControllerRepresentable {

    private var controller = UIViewController()
    private(set) var textView = UITextView()
    private weak var coordinator: Coordinator?
    
    private(set) var attributedText: NSMutableAttributedString
    
    private let defaultFontSize = UIFont.systemFontSize
    private let defaultFontName = "AvenirNext-Regular"
    private var defaultFont: UIFont {
        return UIFont(name: defaultFontName, size: defaultFontSize) ?? .systemFont(ofSize: defaultFontSize)
    }
    
    init(attributedText: NSMutableAttributedString) {
        self.attributedText = attributedText
        self.textView.attributedText = attributedText
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        setUpTextView()
        textView.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        let newCoordinator = Coordinator(self)
        coordinator = newCoordinator
        return newCoordinator
    }
    
    func getCoordinator() -> Coordinator {
        if let coordinator = coordinator {
            return coordinator
        } else {
            return makeCoordinator()
        }
    }

    private func setUpTextView() {
        controller.view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemGray6
        textView.typingAttributes = [.font : defaultFont]
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: controller.view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor)
        ])
    }

    class Coordinator: NSObject, UITextViewDelegate {

        var parent: AttributedTextFieldWrapper

        init(_ parent: AttributedTextFieldWrapper) {
            self.parent = parent
        }
        
        private func updateParentAttributedText() {
            parent.attributedText.setAttributedString(parent.textView.attributedText)
        }
        
        var selectedAttributes: [NSAttributedString.Key : Any] {
            let textRange = parent.textView.selectedRange
            if textRange.isEmpty {
                return [:]
            } else {
                var textAttributes: [NSAttributedString.Key : Any] = [:]
                parent.textView.attributedText.enumerateAttributes(in: textRange) { attributes, range, stop in
                    for item in attributes {
                        textAttributes[item.key] = item.value
                    }
                }
                return textAttributes
            }
        }
        
        // MARK: - Text editing
        
        private func textEffect<T: Equatable>(type: T.Type, key: NSAttributedString.Key, value: Any, defaultValue: T) {
            let range = parent.textView.selectedRange
            if !range.isEmpty {
                let isContain = isContain(type: type, range: range, key: key, value: value)
                let mutableString = NSMutableAttributedString(attributedString: parent.textView.attributedText)
                if isContain {
                    mutableString.removeAttribute(key, range: range)
                    if key == .font {
                        mutableString.addAttributes([key : defaultValue], range: range)
                    }
                } else {
                    mutableString.addAttributes([key : value], range: range)
                }
                parent.textView.attributedText = mutableString
            } else {
                if let current = parent.textView.typingAttributes[key], current as? T == value as? T {
                    parent.textView.typingAttributes[key] = defaultValue
                } else {
                    parent.textView.typingAttributes[key] = value
                }
            }
            updateParentAttributedText()
        }
        
        func makeTextBold() {
            let attributes = parent.textView.selectedRange.isEmpty ? parent.textView.typingAttributes : selectedAttributes
            let fontSize = getFontSize(attributes: attributes)
            
            let defaultFont = UIFont.systemFont(ofSize: fontSize)
            textEffect(type: UIFont.self, key: .font, value: UIFont.boldSystemFont(ofSize: fontSize), defaultValue: defaultFont)
        }
        
        func makeTextUnderline() {
            textEffect(type: Int.self, key: .underlineStyle, value: NSUnderlineStyle.single.rawValue, defaultValue: .zero)
        }
        
        func makeTextItalic() {
            let attributes = parent.textView.selectedRange.isEmpty ? parent.textView.typingAttributes : selectedAttributes
            let fontSize = getFontSize(attributes: attributes)
            
            let defaultFont = UIFont.systemFont(ofSize: fontSize)
            textEffect(type: UIFont.self, key: .font, value: UIFont.italicSystemFont(ofSize: fontSize), defaultValue: defaultFont)
        }
        
        func makeTextStrike() {
            textEffect(type: Int.self, key: .strikethroughStyle, value: NSUnderlineStyle.single.rawValue, defaultValue: .zero)
        }
        
        func setTextAlign(align: NSTextAlignment) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = align
            let selectedRange = parent.textView.selectedRange
            let noteText = parent.textView.attributedText.string as NSString
            let selectedParagraph = noteText.paragraphRange(for: selectedRange)
            if selectedParagraph.isEmpty {
                parent.textView.typingAttributes[.paragraphStyle] = paragraphStyle
            } else {
                let mutableString = NSMutableAttributedString(attributedString: parent.textView.attributedText)
                mutableString.addAttribute(.paragraphStyle, value: paragraphStyle, range: selectedParagraph)
                parent.textView.attributedText = mutableString
                updateParentAttributedText()
            }
        }
        
        func setFontSize(_ fontSize: CGFloat) {
            var font: UIFont
            let attributes = parent.textView.selectedRange.isEmpty ? parent.textView.typingAttributes : selectedAttributes
            let defaultFont = UIFont.systemFont(ofSize: fontSize)
            
            if isContainBoldFont(attributes: attributes) {
                font = UIFont.boldSystemFont(ofSize: fontSize)
            } else if isContainItalicFont(attributes: attributes) {
                font = UIFont.italicSystemFont(ofSize: fontSize)
            } else {
                font = defaultFont
            }
            
            textEffect(type: UIFont.self, key: .font, value: font, defaultValue: defaultFont)
            parent.textView.typingAttributes[.font] = font
        }
        
        func insetImage(_ image: UIImage) {
            let textAttachment = NSTextAttachment(image: scaleImage(image))
            let attachmentString = NSAttributedString(attachment: textAttachment)
            let newString = NSMutableAttributedString(attributedString: parent.textView.attributedText)
            newString.append(attachmentString)
            parent.textView.attributedText = newString
            updateParentAttributedText()
        }
        
        // MARK: - Private funcs
        
        private func isContain<T: Equatable>(type: T.Type, range: NSRange, key: NSAttributedString.Key, value: Any) -> Bool {
            var isContain: Bool = false
            parent.textView.attributedText.enumerateAttributes(in: range) { attributes, range, stop in
                if attributes.filter({ $0.key == key }).contains(where: {
                    $0.value as? T == value as? T
                }) {
                    isContain = true
                    stop.pointee = true
                }
            }
            return isContain
        }
        
        private func isContainBoldFont(attributes: [NSAttributedString.Key : Any]) -> Bool {
            return attributes.contains { attribute in
                if attribute.key == .font, let value = attribute.value as? UIFont {
                    return value == UIFont.boldSystemFont(ofSize: value.pointSize)
                } else {
                    return false
                }
            }
        }
        
        private func isContainItalicFont(attributes: [NSAttributedString.Key : Any]) -> Bool {
            return attributes.contains { attribute in
                if attribute.key == .font, let value = attribute.value as? UIFont {
                    return value == UIFont.italicSystemFont(ofSize: value.pointSize)
                } else {
                    return false
                }
            }
        }
        
        private func getFontSize(attributes: [NSAttributedString.Key : Any]) -> CGFloat {
            if let value = attributes[.font] as? UIFont {
                return value.pointSize
            } else {
                return UIFont.systemFontSize
            }
        }
        
        private func scaleImage(_ image: UIImage) -> UIImage {
            let maxWidth = parent.textView.bounds.width * 0.9
            let maxHeight = parent.textView.bounds.height * 0.9
            let ratio = image.size.width / image.size.height
            let imageW: CGFloat = (ratio >= 1) ? maxWidth : image.size.width*(maxHeight/image.size.height)
            let imageH: CGFloat = (ratio <= 1) ? maxHeight : image.size.height*(maxWidth/image.size.width)
            UIGraphicsBeginImageContext(CGSize(width: imageW, height: imageH))
            image.draw(in: CGRect(x: 0, y: 0, width: imageW, height: imageH))
            let scaledimage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return scaledimage ?? image
        }
        
        // MARK: - Text field delegate
        
        func textViewDidChange(_ textView: UITextView) {
            if textView == parent.textView {
                updateParentAttributedText()
            }
        }
    }
}

extension NSRange {
    var isEmpty: Bool {
        return self.upperBound == self.lowerBound
    }
}
