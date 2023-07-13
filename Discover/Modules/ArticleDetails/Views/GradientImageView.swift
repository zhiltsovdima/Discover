//
//  GradientImageView.swift
//  Discover
//
//  Created by Dima Zhiltsov on 12.07.2023.
//

import UIKit

final class GradientImageView: UIImageView {
    
    private let topGradientLayer = CAGradientLayer()
    private let bottomGradientLayer = CAGradientLayer()
    
    private let labelsStackView = UIStackView()
    private let categoryView = CategoryView()
    private let titleLabel = UILabel()
    private let creatorAndTimeStack = UIStackView()
    private let creatorLabel = UILabel()
    private let timeAgoLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topGradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 2)
        bottomGradientLayer.frame = CGRect(x: 0, y: bounds.height / 2, width: bounds.width, height: bounds.height / 2)
    }
    
    func setupGradient() {
        let darkColor = UIColor.black.withAlphaComponent(0.9).cgColor
        let lightColor = UIColor.clear.cgColor
        topGradientLayer.colors = [darkColor, lightColor]
        topGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        topGradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        bottomGradientLayer.colors = [lightColor, darkColor]
        bottomGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        bottomGradientLayer.endPoint = CGPoint(x: 0, y: 1.0)
        
        layer.addSublayer(topGradientLayer)
        layer.addSublayer(bottomGradientLayer)
        
        contentMode = .scaleAspectFill
    }
    
    func setupLabels(category: String, title: String, creator: String?, timeAgo: String) {
        addSubview(labelsStackView)
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .leading
        labelsStackView.spacing = 5
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false

        categoryView.setup(with: category)

        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.font = Font.header
        
        creatorLabel.text = creator
        creatorLabel.textColor = .white
        creatorLabel.font = Font.generalLight
        creatorLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        timeAgoLabel.text = timeAgo
        timeAgoLabel.textColor = .white
        timeAgoLabel.font = Font.generalLight
        
        creatorAndTimeStack.axis = .horizontal
        creatorAndTimeStack.alignment = .leading
        creatorAndTimeStack.spacing = 10
        
        [categoryView, titleLabel, creatorAndTimeStack].forEach {
            labelsStackView.addArrangedSubview($0)
        }
    
        [timeAgoLabel, creatorLabel].forEach { creatorAndTimeStack.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            titleLabel.widthAnchor.constraint(equalTo: labelsStackView.widthAnchor),
        ])
    }
}
