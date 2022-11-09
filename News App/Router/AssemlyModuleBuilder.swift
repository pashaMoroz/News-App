//
//  AssemlyModuleBuilder.swift
//  News App
//
//  Created by Admin on 07/11/2022.
//

import UIKit

protocol AssemblyBuilderProtocol: AnyObject {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createFavoriteArcticleModule(router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        
        let view = MainViewController()
        let networkService = NetworkService()
        let dataService = DataService()
    
        let presenter = MainPresenter(view: view, networkService: networkService, dataService: dataService, router: router)
        view.presenter = presenter
        return view
    }
        
    func createFavoriteArcticleModule(router: RouterProtocol) -> UIViewController {
        
        let view = FavoriteArticlesViewController()
        let dataService = DataService()
        let presenter = FavoriteArticlesPresenter(view: view, dataService: dataService,  router: router)
        
        view.presenter = presenter
        
        return view
        
    }
    deinit {
        print("ModuleBuilder successfully deinit")
    }
}
