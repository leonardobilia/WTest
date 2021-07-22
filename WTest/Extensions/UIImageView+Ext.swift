//
//  UIImageView+Ext.swift
//  WTest
//
//  Created by Leonardo Bilia on 22/07/21.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
