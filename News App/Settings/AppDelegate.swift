//
//  AppDelegate.swift
//  News App
//
//  Created by Admin on 07/11/2022.
//

import UIKit
import CoreData
import SDWebImageWebPCoder

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let dataService = DataService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let WebPCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(WebPCoder)
        
        return true
    }
    
    // MARK: - Core Data stack
    
    func applicationWillTerminate(_ application: UIApplication) {
        dataService.saveContext()
    }
    
    // MARK: - Core Data stack
}

