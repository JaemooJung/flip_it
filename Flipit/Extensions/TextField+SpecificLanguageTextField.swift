//
//  TextField+SpecificLanguageTextField.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/17.
//

import SwiftUI
import UIKit

class SpecificLanguageTextField: UITextField {
    
    var language: String? {
        didSet {
            if self.isFirstResponder{
                self.resignFirstResponder();
                self.becomeFirstResponder();
            }
        }
    }
    
    override var textInputMode: UITextInputMode? {
        if let language = self.language {
            for inputMode in UITextInputMode.activeInputModes {
                if let inputModeLanguage = inputMode.primaryLanguage, inputModeLanguage == language {
                    return inputMode
                }
            }
        }
        return super.textInputMode
    }
}

struct SpecificLanguageTextFieldView: UIViewRepresentable {

    let placeHolder: String
    var language: String = "en-US"
    @Binding var text: String

    func makeUIView(context: Context) -> UITextField{
        let textField = SpecificLanguageTextField(frame: .zero)
        textField.placeholder = self.placeHolder
        textField.text = self.text
        textField.language = self.language
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
    }

}
