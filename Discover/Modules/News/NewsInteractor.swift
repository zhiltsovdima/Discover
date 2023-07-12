//
//  NewsInteractor.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import Foundation

protocol NewsInteractorProtocol: AnyObject {
    func loadNews(isMoreLoad: Bool)
    func loadImage(for article: Article, completion: @escaping () -> Void)
    func loadImages(for articles: [Article])
}

final class NewsInteractor {
    weak var presenter: NewsPresenterProtocol!
    
    private let newsService: NewsServiceProtocol
    
    private var nextPage: String?
    private var isLoading = false
    
    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
    }
}

// MARK: - NewsInteractorProtocol

extension NewsInteractor: NewsInteractorProtocol {
    
    func loadNews(isMoreLoad: Bool) {
        guard !isLoading else { return }
        isLoading = true
        
        if !isMoreLoad {
            nextPage = nil
        } else {
            presenter.showLoadingIndicator()
        }
        newsService.loadNews(nextPage: nextPage) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let newsData):
                let articles = newsData.results
                nextPage = newsData.nextPage
                presenter.configureNews(with: articles, isMoreLoad: isMoreLoad)
            case .failure(let error):
                let errorMessage = handleFailure(error)
                presenter.showErrorMessage(errorMessage)
                print(errorMessage)
            }
        }
    }
    
    func loadImages(for articles: [Article]) {
        let group = DispatchGroup()
        articles.forEach {
            group.enter()
            loadImage(for: $0) {
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            isLoading = false
            presenter.updateUI()
        }
    }
    
    func loadImage(for article: Article, completion: @escaping () -> Void) {
        guard let _ = article.imageUrl else {
            article.image = R.Images.defaultImage
            completion()
            return
        }
        newsService.loadImage(for: article) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let fetchedImage):
                article.image = fetchedImage
            case .failure(let error):
                let errorMessage = handleFailure(error)
                print(errorMessage)
                article.image = R.Images.brokenImage
            }
            completion()
        }
    }
}

// MARK: - Private Methods

extension NewsInteractor {
    
    private func handleFailure(_ error: Error) -> String {
        switch error {
        case let networkError as NetworkError:
            return networkError.description
        case let codingError as DataCodingError:
            return codingError.description
        default:
            return error.localizedDescription
        }
    }
}
