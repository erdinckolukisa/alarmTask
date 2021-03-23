//
//  NewsTableViewCell.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/19/21.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    func displayNews(_ newsViewModel: NewsViewModel?) {
        if let newsViewModel = newsViewModel {
            newsTitleLabel.text = newsViewModel.title
            newsImageView.sd_setImage(with: URL(string: newsViewModel.imageUrl),
                                     placeholderImage: UIImage(named: "placeholder.png"))
            dateLabel.text = newsViewModel.formattedDate
            
        }
    }
    
}
