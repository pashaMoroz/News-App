//
//  FavoriteArticleViewController.swift
//  News App
//
//  Created by Admin on 09/11/2022.
//

import UIKit

class FavoriteArticlesViewController: UITableViewController {
    
    // MARK: - Properties
    
    var presenter: FavoriteArticlesPresenterProtocol!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    // MARK: - Helpers
    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 150
        tableView.register(ArticleCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    
        navigationItem.title = "Favorite Articles"
    
    }
    
    deinit {
        print("FavoriteArticlesViewController successfully deinited")
    }
}

// MARK: - UITableViewDataSource

extension FavoriteArticlesViewController  {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.favoriteArticles?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ArticleCell
        
        cell.articleFavoriteInfo = presenter.favoriteArticles?[indexPath.row]
        
        return cell
    }
}

// MARK: - FavoriteArticlesViewProtocol

extension FavoriteArticlesViewController: FavoriteArticlesViewProtocol {
    
    func updateView() {
        tableView.reloadData()
    }
}
