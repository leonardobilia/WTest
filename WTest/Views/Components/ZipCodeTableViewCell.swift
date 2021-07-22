//
//  ZipCodeTableViewCell.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import UIKit

class ZipCodeTableViewCell: UITableViewCell {

    private lazy var zipCodeLabel = UILabel()
    private lazy var designationLabel = UILabel()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
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
    }
    
    //MARK: - Methods
    
    func populate(content: ZipCode) {
        zipCodeLabel.text = content.zipCode
        designationLabel.text = content.designation
    }
}

// MARK: - UI

extension ZipCodeTableViewCell {
    
    private func setupUI() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(zipCodeLabel)
        stackView.addArrangedSubview(designationLabel)

        zipCodeLabel.font = .boldSystemFont(ofSize: zipCodeLabel.font.pointSize)

        NSLayoutConstraint.activate([
            zipCodeLabel.widthAnchor.constraint(equalToConstant: 98),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
