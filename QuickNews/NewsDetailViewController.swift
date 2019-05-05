//
//  NewsDetailViewController.swift
//  QuickNews
//
//  Created by Wayne Hsiao on 2019/4/29.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
import SDWebImage
import MyUIKit

class NewsDetailViewController: CustomViewController {
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            guard let imageURL = imageURL,
                let url = URL(string: imageURL) else {
                return
            }
            imageView.sd_setImage(with: url, completed: nil)
            if NewsDetailViewConfigurations.shared.enableTapDismiss {
                let gesture = UITapGestureRecognizer(target: self, action: #selector(NewsDetailViewController.dismissSelf))
                gesture.numberOfTapsRequired = 1
                imageView.addGestureRecognizer(gesture)
                imageView.isUserInteractionEnabled = true
            }
        }
    }
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var contentView: UITextView! {
        didSet {
            guard let content = content else {
                contentView.text = ""
                return
            }
            contentView.text = content
        }
    }
    var imageURL: String?
    var content: String?

    static func controllerWith(imageURL: String, content: String) -> NewsDetailViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let instance = storyboard.instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController else {
            return nil
        }
        instance.imageURL = imageURL
        instance.content = content
        return instance
    }

    private init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
