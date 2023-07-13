//
//  CategoryView.swift
//  Discover
//
//  Created by Dima Zhiltsov on 12.07.2023.
//

import UIKit

final class CategoryView: UIView {
    
    private let categoryLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    func setup(with category: String) {
        backgroundColor = .systemBlue
        
        addSubview(categoryLabel)
        categoryLabel.text = category
        categoryLabel.textColor = .white
        categoryLabel.font = Font.generalBold
        categoryLabel.sizeToFit()
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            widthAnchor.constraint(equalTo: categoryLabel.widthAnchor, constant: 20),
            heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
