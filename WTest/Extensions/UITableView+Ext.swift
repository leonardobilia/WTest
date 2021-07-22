//
//  UITableView+Ext.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import UIKit

extension UITableViewCell {
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
}
