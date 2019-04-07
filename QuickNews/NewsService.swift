//
//  NewsService.swift
//  QuickNews
//
//  Created by Wayne Hsiao on 2019/4/7.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import MyService

extension Service {

    typealias NewsNetworkCompletionHandler = (News?, URLResponse?, Error?) -> Void

    func getNews(type: NewsType, page: Int, complete: @escaping NewsNetworkCompletionHandler) {
        let page = String(page)
        switch type {
        case .type(let typeString):
            let apiToken = "8e6db7b3b8724cc39be774d19c2872c4"
            guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(typeString)&apiKey=\(apiToken)&page=\(page)") else {
                let error = NSError(domain: "com.wayne.quicknews", code: 0, userInfo: nil)
                complete(nil, nil, error)
                return
            }
            get(url: url) { (data, response, error) in
                do {
                    //here dataResponse received from a network request
                    guard let jsonData = data else {
                        complete(nil, response, error)
                        return
                    }
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        jsonData, options: [])
                    guard let jsonDictionary = jsonResponse as? [AnyHashable: Any] else {
                        let error = NSError(domain: "com.wayne.quicknews", code: 0, userInfo: nil)
                        complete(nil, nil, error)
                        return
                    }

                    let articles = jsonDictionary["articles"].map { (articles) -> [Article] in
                        guard let articles = articles as? [[AnyHashable: Any]] else {
                            return []
                        }
                        return articles.compactMap { (article) -> Article? in
                            guard let sourceDictionary = article["source"] as? [AnyHashable: Any] else {
                                return nil
                            }
                            let sourceId = sourceDictionary["id"] as? String ?? ""
                            let sourceName = sourceDictionary["name"] as? String ?? ""
                            let source = Source(sourceId: sourceId, name: sourceName)
                            let author = article["author"] as? String ?? ""
                            let title = article["title"] as? String ?? ""
                            let description = article["description"] as? String ?? ""
                            let url = article["url"] as? String ?? ""
                            let urlToImage = article["urlToImage"] as? String ?? ""
                            let publishedAt = article["publishedAt"] as? String ?? ""
                            let content = article["content"] as? String ?? ""
                            return Article(source: source,
                                           author: author,
                                           title: title,
                                           description: description,
                                           url: url,
                                           urlToImage: urlToImage,
                                           publishedAt: publishedAt,
                                           content: content)
                        }
                    }
                    let status = jsonDictionary["status"].map { (status) -> NewsStatus in
                        guard let statusString = status as? String else {
                            return NewsStatus.failure
                        }
                        if statusString == "ok" {
                            return NewsStatus.success
                        } else {
                            return NewsStatus.failure
                        }
                    }
                    let totalResults = jsonDictionary["totalResults"].map { (totalResults) -> Int in
                        return totalResults as? Int ?? 0
                    }

                    guard let statusWrapped = status,
                        statusWrapped == .success,
                        let totalResultsWrapped = totalResults,
                        let articlesWrapped = articles else {
                            let error = NSError(domain: "com.wayne.quicknews", code: 0, userInfo: nil)
                            complete(nil, nil, error)
                            return
                    }

                    let news = News(status: statusWrapped,
                                    totalResult: totalResultsWrapped,
                                    articles: articlesWrapped)
                    complete(news, response, error)
                } catch let parsingError {
                    complete(nil, nil, parsingError)
                }
            }
        }
    }
}
