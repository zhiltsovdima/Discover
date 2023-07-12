//
//  NewsViewController.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit

protocol NewsViewProtocol: AnyObject {
    func updateUI()
}

final class NewsViewController: UIViewController {
    var presenter: NewsPresenterProtocol!
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        setupAppearance()
        setupViews()
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
        view.addSubview(tableView)
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
}

//MARK: - NewsViewProtocol

extension NewsViewController: NewsViewProtocol {
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            tableView.reloadData()
        }
    }
}
