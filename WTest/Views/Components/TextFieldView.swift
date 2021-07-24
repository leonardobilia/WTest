//
//  TextFieldView.swift
//  WTest
//
//  Created by Leonardo Bilia on 22/07/21.
//

import UIKit

// Created this class to avoid the duplication of several text fields components.
// It also handles changes on the text fields base on the user's actions and inputs.

class TextFieldView: UIView {
    
    enum TextFieldStyle {
        case regular
        case picker
        case presenter
    }
    
    enum ValidationType {
        case base
        case email
    }
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var validationType: ValidationType = .base
    var completion: (() -> Void)?
    var validated = false
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.delegate = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Properties
    
    var text: String? {
        didSet {
            textField.text = text
        }
    }
    
    var textColor: UIColor? {
        didSet {
            textField.textColor = textColor
        }
    }
    
    var autocapitalization: UITextAutocapitalizationType = .none {
        didSet {
            textField.autocapitalizationType = autocapitalization
        }
    }
    
    var input: UIView? {
        didSet {
            textField.inputView = input
        }
    }
    
    var style: TextFieldStyle = .regular {
        didSet {
            arrowImageView.isHidden = style == .regular
            arrowImageView.image = UIImage(systemName: style == .picker ? "chevron.down" : "chevron.right")
        }
    }
    
    var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }
    
    var accessoryView: UIView? {
        didSet {
            textField.inputAccessoryView = accessoryView
        }
    }
    
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    // MARK: - Actions
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.text = text
        
        switch validationType {
        case .base:
            validated = !text.isEmpty
            
        case .email:
            textField.textColor = !text.validEmailAddress() ? .red : .black
            validated = !text.isEmpty && textField.textColor == .black
        }
        completion?()
    }
}

// MARK: - UITextFieldDelegate

extension TextFieldView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.placeholder == Constants.Form.zipCodeFieldPlaceholder {
            textField.resignFirstResponder()
            completion?()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.placeholder == Constants.Form.numbersFieldPlaceholder {
            let allowedCharacterSet = CharacterSet.decimalDigits
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let content = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return content
        }
        
        if textField.placeholder == Constants.Form.uppercasedAndHyphensFieldPlaceholder {
            let allowedCharacterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVXWYZ-")
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let content = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return content
        }
        return true
    }
}

// MARK: - UI

extension TextFieldView {
    private func setupUI() {
        addSubview(textField)
        addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            arrowImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
