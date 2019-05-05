//
//  Configurations.swift
//  QuickNews
//
//  Created by Wayne Hsiao on 2019/5/5.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit

protocol Configrations {
    var configurationsDictionary: [String: Any] { get }
}

extension Configrations {
    func dictionaryFrom(plist: String) -> [String: Any] {
        var propertyList = PropertyListSerialization.PropertyListFormat.xml
        guard let plistPath = Bundle.main.path(forResource: plist, ofType: "plist"),
            let plistXML = FileManager.default.contents(atPath: plistPath) else {
                return [String: Any]()
        }
        do {
            guard let plistData = try PropertyListSerialization.propertyList(from: plistXML,
                                                                             options: .mutableContainers,
                                                                             format: &propertyList) as? [String: Any] else {
                                                                                return [String: Any]()
            }
            return plistData
        } catch {
            return [String: Any]()
        }
    }
}

class NewsDetailViewConfigurations: Configrations {
    static let shared = NewsDetailViewConfigurations()
    lazy var configurationsDictionary: [String: Any] = {
        let config = dictionaryFrom(plist: "NewsDetailViewConfig")
        return config
    }()

    lazy var enableTapDismiss: Bool = {
        guard let result = configurationsDictionary["enableTapDismiss"] as? Bool else {
            return false
        }
        return result
    }()
}
