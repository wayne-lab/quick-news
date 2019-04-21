//
//  NewsTableViewController.swift
//  QuickNews
//
//  Created by Wayne Hsiao on 2019/4/10.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import MyUIKit
import MyService
import SDWebImage
import SafariServices

class NewsTableViewController: CustomRefreshTableViewController, CustomRefreshTableViewControllerDelegate {

    var news: News?
    var currentPage: Int = 1
    var footerView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        refreshControlDelegate = self
        getMoreNews {
            
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let rect = tableView.frame
        tableView.frame = CGRect(x: rect.origin.x,
                                 y: rect.origin.y,
                                 width: rect.width,
                                 height: rect.height-25)
        addFooterView()
        tableView.reloadData()
    }

    func addFooterView() {
        let window = UIApplication.shared.keyWindow!
        let footerViewFound = window.subviews.filter {
            $0 == self.footerView
        }.first
        guard footerViewFound == nil else {
            return
        }
        let rect = CGRect(x: 0, y: view.frame.maxY, width: view.bounds.width, height: 25)
        let footerView = UITextView(frame: rect)
        let attributedString = NSMutableAttributedString(string: "Powered by NewsAPI.org")
        let url = URL(string: "https://newsapi.org")!
        #if !MonkeyTest
        attributedString.setAttributes([.link: url],
                                       range: NSRange(location: 11, length: 11))
        #endif
        footerView.attributedText = attributedString
        footerView.isUserInteractionEnabled = true
        footerView.isEditable = false
        footerView.linkTextAttributes = [
            .foregroundColor: UIColor.blue
        ]
        self.footerView = footerView
        window.addSubview(footerView)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.articles.count ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if let newsCell = cell as? NewsTableViewCell, let articles = news?.articles {
            let article = articles[indexPath.row]
            newsCell.titleLabel.text = article.title
            if let url = URL(string: article.urlToImage) {
                newsCell.backgroundImageView.sd_setImage(with: url, completed: nil)
            }
            return newsCell
        }
        return cell
    }

    open func refresh(pullDirection: MyUIKit.PullDirection,
                      complete: @escaping () -> Void) {
        switch pullDirection {
        case .pullDown:
            resetNewsAndPage()
            getMoreNews(complete: complete)
        case .pullUp:
            getMoreNews(complete: complete)
        case .unknow:
            break
        }
    }

    func getMoreNews(complete: @escaping () -> Void) {
        currentPage += 1
        Service.shared.getNews(type: NewsType.type(NewsType.apple), page: currentPage) { (pNews, _, error) in
            guard error == nil else {
                complete()
                return
            }
            if self.news != nil {
                guard let articles = pNews?.articles else {
                    complete()
                    return
                }
                self.news?.articles.append(contentsOf: articles)
            } else {
                self.news = pNews
            }
            complete()
            DispatchQueue.main.async {
                let previousLastRow = max(self.tableView.numberOfRows(inSection: 0) - 1, 0)
                self.tableView.reloadData()

                guard let news = self.news, previousLastRow > 0 else {
                    return
                }
                let currentLastRow = max(news.articles.count - 1, 0)
                guard currentLastRow > previousLastRow else {
                    return
                }
                let indexPath = currentLastRow > previousLastRow ?
                    IndexPath(row: previousLastRow + 1, section: 0) : IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                let cell = self.tableView(self.tableView, cellForRowAt: indexPath)
                self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x,
                                                       y: self.tableView.contentOffset.y - cell.bounds.height / 2)
            }
        }
    }

    open func willShowRefreshController(_ pullDirection: MyUIKit.PullDirection) -> Bool {
        switch pullDirection {
        case .pullDown:
            return true
        case .pullUp:
            return currentPage <= 5 ? true : false
        case .unknow:
            return false
        }
    }

    func resetNewsAndPage() {
        currentPage = 1
        news = nil
    }
}

extension NewsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        #if MonkeyTest
            return
        #else
            if let articles = news?.articles {
                let article = articles[indexPath.row]
                let urlString = article.url
                if let url = URL(string: urlString) {
                    let config = SFSafariViewController.Configuration()
                    config.entersReaderIfAvailable = true
                    config.barCollapsingEnabled = true
                    let safari = SFSafariViewController(url: url, configuration: config)
                    present(safari, animated: true)
                }
            }
        #endif
    }
}
