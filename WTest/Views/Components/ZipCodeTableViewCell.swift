//
//  ZipCodeTableViewCell.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import UIKit

class ZipCodeTableViewCell: UITableViewCell {

    private lazy var infoLabel = UILabel()

    //MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Methods
    
    func populate(content: ZipCode) {
        infoLabel.attributedText = attributed(text: content.info)
    }
    
    private func attributed(text: String) -> NSAttributedString? {
        let attributedQuote = NSMutableAttributedString(string: text)
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: infoLabel.font.pointSize)]
        attributedQuote.addAttributes(attributes, range: NSRange(location: 0, length: 8))
        return attributedQuote
    }
}

// MARK: - UI

extension ZipCodeTableViewCell {
    
    private func setupUI() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(infoLabel)

        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
