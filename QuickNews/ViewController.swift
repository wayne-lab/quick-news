//
//  ViewController.swift
//  QuickNews
//
//  Created by Wayne Hsiao on 2019/4/7.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import MyService

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let service = Service.shared
        service.getNews(type: .type(NewsType.apple), page: 1) { (news, _, _) in
            guard let news = news else {
                return
            }
            print(news)
        }
    }
}
