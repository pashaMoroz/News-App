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
    var presenter: MainViewPresenterProtocol!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    private func setupActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.color = .black
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
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
    
  
    // MARK: - scrollViewDidEndDragging (Pagination)
     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
            if !isDataLoading {
                guard let countOfArticles = presenter?.articles?.articles?.count else {
                    return
                }
                
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

    // MARK: - MainViewProtocol
extension MainViewController: MainViewProtocol {
    
    func succes() {
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error)
    }
}
