//
//  FavoritesController.swift
//  Discover
//
//  Created by Dima Zhiltsov on 12.07.2023.
//

import UIKit

protocol FavoritesViewProtocol: AnyObject {
    func updateUI()
}

final class FavoritesController: UIViewController {
    var presenter: FavoritesPresenterProtocol!
    
    private let tableView = UITableView()
    private let scrollButton = ScrollToTopButton()
    
    private var isScrolingDown = false {
        didSet {
            scrollButton.isHidden = !isScrolingDown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.updateNews()
    }
    
    @objc func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

extension FavoritesController {
    private func setupAppearance() {
        view.backgroundColor = .systemBackground
        title = R.Strings.TabBar.favorites
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: R.Identifiers.articleCell)
        tableView.backgroundColor = .clear
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        view.addSubview(scrollButton)
        scrollButton.isHidden = true
        scrollButton.translatesAutoresizingMaskIntoConstraints = false
        scrollButton.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scrollButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scrollButton.widthAnchor.constraint(equalToConstant: 40),
            scrollButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

//MARK: - UITableViewDataSource

extension FavoritesController: UITableViewDataSource {
    
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

extension FavoritesController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ScrollViewDidScroll

extension FavoritesController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        isScrolingDown = offsetY > 0 ? true : false
    }
}

// MARK: - FavoritesViewProtocol

extension FavoritesController: FavoritesViewProtocol {
    func updateUI() {
        tableView.reloadData()
    }
}
