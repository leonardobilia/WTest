//
//  Constants.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import Foundation

struct Constants {
    struct Title {
        static let zipCode = "Códigos Postais"
        static let articles = "Artigos"
        static let form = "Formulário"
    }
    
    struct ZipCode {
        static let searchPlaceholder = "Buscar"
    }
    
    struct Form {
        static let buttonTitle = "Validar"
        static let freeFieldPlaceholder = "Texto Livre"
        static let emailFieldPlaceholder = "E-mail"
        static let numbersFieldPlaceholder = "Numeros"
        static let uppercasedAndHyphensFieldPlaceholder = "Versais e Hífens"
        static let dateFieldPlaceholder = "Data"
        static let selectionFieldPlaceholder = "Qualidate"
        static let zipCodeFieldPlaceholder = "Designicação Postal"
    }
    
    struct AlertTitle {
        static let oops = "Oops!"
        static let awesome = "Uhuuu!"
    }
    
    struct AlertMessage {
        static let formValidated = "Todos os campos foram validados com sucesso."
    }
    
    struct AlertAction {
        static let ok = "Ok"
    }
}
