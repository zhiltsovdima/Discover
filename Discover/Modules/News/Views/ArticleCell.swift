//
//  ArticleCell.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit

protocol ArticleCellProtocol: AnyObject {
    func setup(with article: Article)
}

final class ArticleCell: UITableViewCell {
    private let articleImage = UIImageView()
    private let verticalStack = UIStackView()
    private let creatorDateStack = UIStackView()
    
    private let title = UILabel()
    private let creatorLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ArticleCellProtocol

extension ArticleCell: ArticleCellProtocol {
    func setup(with article: Article) {
        title.text = article.title
        creatorLabel.text = article.creator
        dateLabel.text = article.dateString
        articleImage.image = article.image
    }
}

// MARK: - Setup UI

extension ArticleCell {
    
    private func setupViews() {
        backgroundColor = .clear
        
        [articleImage, verticalStack].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [title, creatorDateStack].forEach { verticalStack.addArrangedSubview($0) }
        [creatorLabel, dateLabel].forEach { creatorDateStack.addArrangedSubview($0) }
        
        verticalStack.axis = .vertical
        verticalStack.alignment = .leading
        
        creatorDateStack.axis = .horizontal
        creatorDateStack.spacing = 10
        
        articleImage.contentMode = .scaleAspectFill
        articleImage.layer.cornerRadius = 20
        articleImage.clipsToBounds = true
        
        title.numberOfLines = 0
        title.font = Font.headerCell
        title.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        creatorLabel.numberOfLines = 0
        creatorLabel.font = Font.generalLight
        creatorLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        dateLabel.numberOfLines = 0
        dateLabel.textAlignment = .right
        dateLabel.font = Font.generalLight
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            articleImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            articleImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            articleImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            articleImage.widthAnchor.constraint(equalTo: articleImage.heightAnchor),
            
            verticalStack.topAnchor.constraint(equalTo: articleImage.topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: articleImage.trailingAnchor, constant: 10),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            verticalStack.bottomAnchor.constraint(equalTo: articleImage.bottomAnchor),
            
            title.widthAnchor.constraint(equalTo: verticalStack.widthAnchor),
            creatorDateStack.widthAnchor.constraint(equalTo: verticalStack.widthAnchor)
        ])
    }
}
