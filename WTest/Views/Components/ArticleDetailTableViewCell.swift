//
//  ArticleDetailTableViewCell.swift
//  WTest
//
//  Created by Leonardo Bilia on 22/07/21.
//

import UIKit

class ArticleDetailTableViewCell: UITableViewCell {

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titlelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var publishedAtLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.textAlignment = .justified
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
        bodyLabel.text = content.body
        
        // NOTE:
        // Avatar not loading due to access restriction to the provided URL.
        // Server Response: this object has been disabled
        // I have applied a color background to make the rounded image visible.

        if let avatar = content.avatar {
            avatarImageView.load(url: URL(string: avatar)!)
        }
    }
}

// MARK: - UI

extension ArticleDetailTableViewCell {
    
    private func setupUI() {
        contentView.addSubview(titlelabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(publishedAtLabel)

        #if SECONDARY
        contentView.addSubview(avatarImageView)
        avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        titlelabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8).isActive = true
        #else
        titlelabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        #endif
        
        titlelabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32).isActive = true
        titlelabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        stackView.topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 4).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        bodyLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -48).isActive = true
    }
}
