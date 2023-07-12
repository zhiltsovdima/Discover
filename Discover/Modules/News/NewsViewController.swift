//
//  NewsViewController.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit

protocol NewsViewProtocol: AnyObject {
    func updateUI()
    func stopRefreshing()
    func hideLoadingIndicator()
    func showLoadingIndicator()
    func showErrorMessage(_ error: String)
}

final class NewsViewController: UIViewController {
    var presenter: NewsPresenterProtocol!
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let loadingIndicator = LoadingIndicatorView()
    private let scrollButton = ScrollToTopButton()
    private let errorLabel = UILabel()
    
    private var isScrolingDown = false {
        didSet {
            scrollButton.isHidden = !isScrolingDown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        presenter.updateNews(isMoreLoad: false)
        setupAppearance()
        setupViews()
    }
    
    @objc private func pulledToRefresh() {
        presenter.updateNews(isMoreLoad: false)
    }
    
    @objc func scrollToTop() {        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

//MARK: - Setup UI

extension NewsViewController {
    
    private func setupAppearance() {
        view.backgroundColor = .systemBackground
        title = R.Strings.appTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: R.Identifiers.articleCell)
        tableView.backgroundColor = .clear
        tableView.frame = view.bounds
        tableView.tableFooterView = loadingIndicator
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
        view.addSubview(tableView)
        
        view.addSubview(errorLabel)
        errorLabel.font = .systemFont(ofSize: 14)
        errorLabel.textColor = .red
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollButton)
        scrollButton.isHidden = true
        scrollButton.translatesAutoresizingMaskIntoConstraints = false
        scrollButton.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
        NSLayoutConstraint.activate([
            scrollButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scrollButton.widthAnchor.constraint(equalToConstant: 40),
            scrollButton.heightAnchor.constraint(equalToConstant: 40),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        ])
    }
    
    func setupRefreshControl() {
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        refreshControl.beginRefreshing()
    }
    
}

//MARK: - UITableViewDataSource

extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Identifiers.articleCell) as! ArticleCell
        presenter.configure(cell: cell, at: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ScrollViewDidScroll

extension NewsViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height && offsetY > 0 {
            presenter.updateNews(isMoreLoad: true)
        }
        
        isScrolingDown = offsetY > 0 ? true : false
    }
}

//MARK: - NewsViewProtocol

extension NewsViewController: NewsViewProtocol {
    func updateUI() {
        errorLabel.isHidden = true
        tableView.reloadData()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    func showLoadingIndicator(){
        loadingIndicator.startAnimating()
    }
    
    func stopRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func showErrorMessage(_ error: String) {
        errorLabel.text = error
        errorLabel.isHidden = false
    }
}
