//
//  ZipCodeTableViewCell.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import UIKit

class ZipCodeTableViewCell: UITableViewCell {

    private lazy var zipcode = UILabel()
    private lazy var location = UILabel()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    //MARK: - Methods
    
    func populate(content: ZipCode) {
        zipcode.text = content.zipcode
        location.text = content.designation
    }
}

// MARK: - UI

extension ZipCodeTableViewCell {
    
    private func setupUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(zipcode)
        stackView.addArrangedSubview(location)

        zipcode.font = .boldSystemFont(ofSize: zipcode.font.pointSize)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
