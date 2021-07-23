//
//  ArticleTableViewCell.swift
//  WTest
//
//  Created by Leonardo Bilia on 22/07/21.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    private lazy var titlelabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var publishedAtLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    func populate(content: Article.Item) {
        titlelabel.text = content.title
        authorLabel.text = content.author
        publishedAtLabel.text = content.publishedAt.dateFormatter()
        
        if let summary = content.summary {
            summaryLabel.text = summary
            summaryLabel.numberOfLines = 0
        } else {
            summaryLabel.text = content.body
            summaryLabel.numberOfLines = 6
        }
    }
}

// MARK: - UI

extension ArticleTableViewCell {
    
    private func setupUI() {
        contentView.addSubview(titlelabel)
        contentView.addSubview(summaryLabel)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(authorLabel)
        
        #if SECONDARY
        stackView.addArrangedSubview(publishedAtLabel)
        #endif
        
        NSLayoutConstraint.activate([
            titlelabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titlelabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titlelabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        
            summaryLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            summaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            summaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            summaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
