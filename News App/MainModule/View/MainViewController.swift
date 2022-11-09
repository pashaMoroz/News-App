//
//  ViewController.swift
//  News App
//
//  Created by Admin on 07/11/2022.
//

import UIKit

let cellReuseIdentifier = "ArticleCell"

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private var isDataLoading: Bool = false
    private let activityIndicator = UIActivityIndicatorView()
    private let footerView = UIView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let refresher = UIRefreshControl()
    var presenter: MainViewPresenterProtocol!
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureTableView()
    }
    
    // MARK: - Helpers
    private func configureTableView() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.rowHeight = 150
        tableView.register(ArticleCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        footerView.isHidden = true
        footerView.addSubview(activityIndicator)
        
        navigationItem.title = "Articles"
        
        setupActivityIndicator()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(showFavorite))
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    private func setupActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.color = .black
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Seaech"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    // MARK: - Actions
    
    @objc func showFavorite() {
        presenter.showFavorite()
    }
    
    @objc func handleRefresh() {
        presenter.getArticles()
        refresher.endRefreshing()
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.articles?.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ArticleCell
        
        cell.articleInfo = presenter.articles?.articles?[indexPath.row]
        
        footerView.isHidden = true
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isDataLoading = false
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let article = presenter.articles?.articles?[indexPath.row]
        
        let favofiteAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            completion(self.presenter.isFavoriteArticle(article: article, isNeedToUpdate: true))
        }
        
        let isFavorite = self.presenter.isFavoriteArticle(article: article, isNeedToUpdate: false)
        
        favofiteAction.image = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        favofiteAction.backgroundColor = UIColor(red: 0.09, green: 0.63, blue: 0.52, alpha: 1.00)

        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [favofiteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
    
    
    // MARK: - scrollViewDidEndDragging (Pagination)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
            if !isDataLoading {
                guard let countOfArticles = presenter?.articles?.articles?.count else { return }
                
#warning("Developer accounts are limited to a max of 100 results. You are trying to request results 0 to 110. Please upgrade to a paid plan if you need more results, so I did countOfArticles != 100")
                
                if Link.offset + Link.limit - countOfArticles == Link.limit && countOfArticles != 100 {
                    footerView.isHidden = false
                    isDataLoading.toggle()
                    presenter?.getArticles()
                }
            }
        }
    }
}

// MARK:  UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        tableView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        
    }
}

// MARK:  UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
//        filteredUsers = users.filter({ $0.username.contains(searchText) })
        
//        presenter.filteredArticles = presenter.articles?.articles?.filter({$0.title?.contains(searchText)!}) ?? [ArticleInfo?]
        
        guard var articles = presenter.articles?.articles else { return }
        guard var filteredArticles = presenter.filteredArticles else { return }
        
        //filteredArticles = articles.filter({$0.title?.lowercased()?.contains(searchText.lowercased())})
        //filteredArticles = articles.filter({$0.title?.lowercased().contains(searchText.lowercased())})
    }
}

// MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    
    func succes() {
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error)
    }
}
