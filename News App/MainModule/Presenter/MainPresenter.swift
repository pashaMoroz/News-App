//
//  MainPresenter.swift
//  News App
//
//  Created by Admin on 07/11/2022.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func getArticles()
  //  func tapOnTheArticle(article: Arbticle?)
    var articles: Article? { get set }
    var networkService: NetworkServiceProtocol? { get set }
}

final class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    var networkService: NetworkServiceProtocol?
    var articles: Article?
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getArticles()
    }
    
    func getArticles() {
        Link.page += 1
        networkService?.getArticle { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let article) :
                    self.articles = article
                    self.view?.succes()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
//    func tapOnTheComment(comment: Article?) {
//        router?.showDetail(comment: comment)
//    }
    
    deinit {
        print("MainPresenter successfully deinit")
    }
}
