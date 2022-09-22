//
//  Article.swift
//  NewsApp
//
//  Created by vitor henrique on 22/09/22.
//

import Foundation

struct ArticlesList: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let title: String?
    let description: String?
}
