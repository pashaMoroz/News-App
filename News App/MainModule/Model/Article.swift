//
//  Article.swift
//  News App
//
//  Created by Admin on 07/11/2022.
//

import Foundation

struct Article: Decodable {
    let status: String?
    let totalResults: Int?
    let articles: [ArticleInfo]?
}

// MARK: - Article
struct ArticleInfo: Decodable {
    let source: Source?
    let author: String?
    let title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source
struct Source: Decodable {
    let id: String?
    let name: String?
}
