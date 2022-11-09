//
//  FavoriteArticlesPresenter.swift
//  News App
//
//  Created by Admin on 09/11/2022.
//

import Foundation
import CoreData

protocol FavoriteArticlesViewProtocol: AnyObject {
    func updateView()
}

protocol FavoriteArticlesPresenterProtocol: AnyObject {
    init(view: FavoriteArticlesViewProtocol, dataService: DataService, router: RouterProtocol)
    func fetchDataFromCoreData()
    var favoriteArticles: [FavoriteArticle]? { get set }
    var dataService: DataService? { get set }
}


class FavoriteArticlesPresenter: FavoriteArticlesPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: FavoriteArticlesViewProtocol?
    var dataService: DataService?
    var favoriteArticles: [FavoriteArticle]?
    var router: RouterProtocol?
    
    
    required init(view: FavoriteArticlesViewProtocol, dataService: DataService, router: RouterProtocol) {
        
        self.view = view
        self.router = router
        self.dataService = dataService
        
        fetchDataFromCoreData()
    }
    
    func fetchDataFromCoreData() {
       let fetchRequest: NSFetchRequest<FavoriteArticle> = FavoriteArticle.fetchRequest()
       let sort = NSSortDescriptor(key: "url", ascending: true)
       fetchRequest.sortDescriptors = [sort]
       do {
           favoriteArticles = try dataService?.persistentContainer.viewContext.fetch(fetchRequest)
       } catch let error {
           print(error)
       }
   }
    
    deinit {
        print("FavoriteArticlesPresenter successfully deinited")
    }
}
