//
//  News.swift
//  QuickNews
//
//  Created by Wayne Hsiao on 2019/4/7.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

struct Article {
    let source: Source
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
}

enum NewsType {
    static let bitcon = "bitcon"
    static let apple = "apple"
    case type(_ :String)
}

enum NewsStatus {
    case success, failure
}

struct Source {
    let sourceId: String
    let name: String
}

struct News {
    let status: NewsStatus
    let totalResult: Int
    let articles: [Article]
}
