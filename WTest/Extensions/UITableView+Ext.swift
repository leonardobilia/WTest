//
//  UITableView+Ext.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import UIKit

extension UITableViewCell {
    
    // It converts the table view cell's name into an identifier for registering the cell and making sure every cell has a different identifier.
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
}
