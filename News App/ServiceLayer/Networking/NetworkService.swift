//
//  NetworkService.swift
//  News App
//
//  Created by Admin on 07/11/2022.
//

import Foundation

private let apiKey = "cea019f4d4874c2a83549b5c1477bcb9"

protocol NetworkServiceProtocol {
    func getArticle(completion: @escaping (Result<Article?, Error>) -> Void)
    var link: Link { get set }
}

class NetworkService: NetworkServiceProtocol {
    
    var link = Link()
    
    func getArticle(completion: @escaping (Result<Article?, Error>) -> Void) {
        let urlString = link.createLink(page: Link.page)
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                guard let data = data else { return }
                let obj = try JSONDecoder().decode(Article.self, from: data)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

class Link  {
    
    static var offset: Int {
        return Link.page * Link.limit
    }
    
    static var limit: Int = 10
    static var page: Int = 0
    
    func createLink(page: Int) -> String {

        return "https://newsapi.org/v2/everything?q=keyword&apiKey=\(apiKey)&?page=\(Link.page)&pageSize=\(Link.offset)"
    }
}




