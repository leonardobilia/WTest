//
//  String+Ext.swift
//  WTest
//
//  Created by Leonardo Bilia on 22/07/21.
//

import Foundation

extension String {
    
    func dateFormatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: self) {
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "PT")
            return formatter.string(from: date)
        }
        return "Unknown date"
    }
    
    func validEmailAddress() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}