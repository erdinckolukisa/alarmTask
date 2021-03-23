//
//  Enums.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/20/21.
//

import Foundation

enum TableViewCellNames: String {
    case CategoryTableViewCell
    case NewsTableViewCell
    
    var identifier: String {
        return self.rawValue
    }
}

enum TableViewCellIdentifiers: String {
    case categoryTableViewCell
    case newsTableViewCell
    
    var identifier: String {
        return self.rawValue
    }
}

enum SegueIdentifiers: String {
    case newsList
    case newsDetail
    
    var identifier: String {
        return self.rawValue
    }
}

enum StoryboardControllerIdentifiers: String {
    case newsListVC
    case newsDetailVC
    case searchResultVC
    
    var identifier: String {
        return self.rawValue
    }
}

enum Constants {
    enum Errors {
        static let genericError = "An error occured. Please try again later."
    }
}
