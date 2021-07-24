//
//  Constants.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import Foundation

// The structure was created to manage all app constants and to facilitate localization in the future.
// Each inner structure represents a functionality or feature of the app.

struct Constants {
    struct Title {
        static let zipCode = "Códigos Postais"
        static let articles = "Artigos"
        static let form = "Formulário"
    }
    
    struct ZipCode {
        static let searchPlaceholder = "Buscar"
    }
    
    struct Article {
        static let commentsHeaderTitle = "Comentários"
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
    
    struct Alert {
        struct Title {
            static let oops = "Oops!"
            static let awesome = "Uhuuu!"
        }
        
        struct Message {
            static let formValidated = "Todos os campos foram validados com sucesso."
        }
        
        struct Action {
            static let ok = "Ok"
        }
    }
}
