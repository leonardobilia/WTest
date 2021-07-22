//
//  Bindable.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import Foundation

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
