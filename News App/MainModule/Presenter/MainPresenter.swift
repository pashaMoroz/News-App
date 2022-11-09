//
//  MainPresenter.swift
//  News App
//
//  Created by Admin on 07/11/2022.
//

import Foundation
import CoreData

protocol MainViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol, dataService: DataService, router: RouterProtocol)
    func getArticles()
    func fetchDataFromCoreData()
    func addToFavorite(article: ArticleInfo)
    func removeFromFavorite(article: FavoriteArticle)
    func isFavoriteArticle(article: ArticleInfo?, isNeedToUpdate: Bool) -> Bool
    func showFavorite()
    
    var articles: Article? { get set }
    var filteredArticles: [ArticleInfo]? { get set }
    var networkService: NetworkServiceProtocol? { get set }
    var dataService: DataService? { get set }
    var listOfFavoriteArticle: [FavoriteArticle]? { get set }
}

final class MainPresenter: MainViewPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    var networkService: NetworkServiceProtocol?
    var articles: Article?
    var filteredArticles: [ArticleInfo]?
    var dataService: DataService?
    var listOfFavoriteArticle: [FavoriteArticle]?
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, dataService: DataService, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.dataService = dataService
        
        self.router = router
        getArticles()
        fetchDataFromCoreData()
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
    
    
     func fetchDataFromCoreData() {
        let fetchRequest: NSFetchRequest<FavoriteArticle> = FavoriteArticle.fetchRequest()
        let sort = NSSortDescriptor(key: "url", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            listOfFavoriteArticle = try dataService?.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
    }
    
    func addToFavorite(article: ArticleInfo) {
        
        guard let dataService = dataService else { return }
        let managedContext = dataService.persistentContainer.viewContext 
        guard let entity = NSEntityDescription.entity(forEntityName: Entities.favoriteArticle.rawValue,
                                                      in: managedContext) else { return }
        let favoriteArticle = NSManagedObject(entity: entity, insertInto: managedContext) as? FavoriteArticle
        
        favoriteArticle?.url = article.url
        favoriteArticle?.title = article.title
        favoriteArticle?.descriptionInfo = article.description
        favoriteArticle?.author = article.author
        favoriteArticle?.sourceName = article.source?.name
        favoriteArticle?.urlToImage = article.urlToImage
            
        do {
            try managedContext.save()
        } catch let error {
            print("Failed to save task", error.localizedDescription)
        }
        view?.succes()
    }
    
    func removeFromFavorite(article: FavoriteArticle) {
        
        dataService?.persistentContainer.viewContext.delete(article)
        do {
            try dataService?.persistentContainer.viewContext.save()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func isFavoriteArticle(article articleInfo: ArticleInfo?, isNeedToUpdate: Bool) -> Bool {
        
        guard let articleInfo = articleInfo else { return false }
        guard let url = articleInfo.url else { return false }
        guard let listUrlOfFavoriteArticles = listOfFavoriteArticle else { return false }
        
        for article in listUrlOfFavoriteArticles {
            if article.url == url {
                isNeedToUpdate ? removeFromFavorite(article: article) : nil
                fetchDataFromCoreData()
                view?.succes()
                return true
            }
        }
        isNeedToUpdate ? addToFavorite(article: articleInfo) : nil
        fetchDataFromCoreData()
        view?.succes()
        return false
    }
    
    func showFavorite() {
        router?.showFavoriteArticles()
    }
    
    deinit {
        print("MainPresenter successfully deinit")
    }
}
