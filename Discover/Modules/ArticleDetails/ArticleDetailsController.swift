//
//  ArticleDetailController.swift
//  Discover
//
//  Created by Dima Zhiltsov on 12.07.2023.
//

import UIKit

protocol ArticleDetailsViewProtocol: AnyObject {
    func updateUI(title: String, category: String, description: String, content: String, image: UIImage, timeAgo: String) 
    func updateFavoriteButton(isFavorite: Bool)
}

final class ArticleDetailsController: UIViewController {
    var presenter: ArticleDetailsPresenterProtocol!
    
    private let scrollView = UIScrollView()
    private let articleImage = GradientImageView()
    private let detailsView = UIView()
    
    private let textStackView = UIStackView()
    private let descriptionLabel = UILabel()
    private let contentLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setupNavBarButtons()
        setupViews()
        setupConstraints()
        presenter.viewDidLoad()
    }
}

// MARK: - Setup UI

extension ArticleDetailsController {
    
    @objc private func favoriteButtonTapped() {
        presenter.favoriteButtonTapped()
    }
    
    @objc private func backButtonTapped() {
        presenter.backButtonTapped()
    }
    
    private func setupAppearance() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavBarButtons() {
        let rightButton = UIBarButtonItem(
            image: R.Images.favorites,
            style: .done,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
        navigationItem.rightBarButtonItem = rightButton
        
        let leftButton = UIBarButtonItem(
            image: R.Images.arrowBack,
            style: .done,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = leftButton
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never

        articleImage.setupGradient()
        
        detailsView.backgroundColor = .systemBackground
        detailsView.layer.cornerRadius = 20
        detailsView.clipsToBounds = true
        detailsView.addSubview(textStackView)

        textStackView.axis = .vertical
        textStackView.spacing = 10
        
        descriptionLabel.font = .boldSystemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        
        contentLabel.font = .systemFont(ofSize: 14)
        contentLabel.numberOfLines = 0
        
        [articleImage, detailsView].forEach {
            scrollView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [descriptionLabel, contentLabel].forEach { textStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            articleImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            articleImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            articleImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            articleImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2),
            articleImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            detailsView.topAnchor.constraint(equalTo: articleImage.bottomAnchor, constant: -20),
            detailsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            detailsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            detailsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            textStackView.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: 40),
            textStackView.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 20),
            textStackView.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -20),
            textStackView.bottomAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: -20),
            
            descriptionLabel.widthAnchor.constraint(equalTo: textStackView.widthAnchor),
            contentLabel.widthAnchor.constraint(equalTo: textStackView.widthAnchor)
        ])
    }
}

// MARK: - ArticleDetailsViewProtocol

extension ArticleDetailsController: ArticleDetailsViewProtocol {
    func updateUI(title: String, category: String, description: String, content: String, image: UIImage, timeAgo: String) {
        descriptionLabel.text = description
        contentLabel.text = content
        articleImage.image = image
        articleImage.setupLabels(category: category, title: title, timeAgo: timeAgo)
    }
    
    func updateFavoriteButton(isFavorite: Bool) {
        navigationItem.rightBarButtonItem?.image = isFavorite ? R.Images.favoritesFill : R.Images.favorites
    }
}

// MARK: - UIScrollViewDelegate

extension ArticleDetailsController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        articleImage.transform = CGAffineTransform(translationX: 0, y: offsetY/2)
    }
}
