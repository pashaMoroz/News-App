//
//  AssemlyModuleBuilder.swift
//  News App
//
//  Created by Admin on 07/11/2022.
//

import UIKit

protocol AssemblyBuilderProtocol: AnyObject {
    func createMainModule(router: RouterProtocol) -> UIViewController
  //  func createDetailModule(comment: Article?, router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        
        let view = MainViewController()
        let networkService = NetworkService()
    
        let presenter = MainPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
//    func createDetailModule(comment: Comment?, router: RouterProtocol) -> UIViewController {
//
//        let view = DetailViewController()
//        var networkService = NetworkService()
//
//        let presenter = DetailPresenter(view: view, networkService: networkService, router: router, comment: comment)
//        view.presentor = presenter
//
//        return view
//    }
    deinit {
        print("ModuleBuilder successfully deinit")
    }
}
