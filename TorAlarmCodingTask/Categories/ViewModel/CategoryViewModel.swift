//
//  CategoryViewModel.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/20/21.
//

import Foundation

struct CategoryViewModel {
    let id: String
    let name: String
    let icon: String
    
    init?(category: Category) {
        guard let id = category.id, let name = category.name, let icon = category.icon else { return nil }
        self.id = id
        self.name = name
        self.icon = icon
    }
}
