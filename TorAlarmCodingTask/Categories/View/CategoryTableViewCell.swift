//
//  CategoryTableViewCell.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/20/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    func displayCategoryInfo(category: CategoryViewModel?) {
        if let category = category {
            categoryIconImageView.image = UIImage(named: category.icon)
            categoryTitleLabel.text = category.name
        }
    }
}
