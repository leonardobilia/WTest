//
//  Bindable.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import Foundation

// The class responsible for handling the bindings between the view models and the controllers.
// Due to the structure and execution time of the project, I chose to create this simple binding instead of using the Apple's combine framework.

class Bindable<T> {
    init(_ value: T) {
        self.value = value
    }
    
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
            }
        }
    }
    
    var valueChanged: ((T) -> Void)?
}
