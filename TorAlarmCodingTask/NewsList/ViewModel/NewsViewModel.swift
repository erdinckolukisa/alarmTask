//
//  NewsViewModel.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/21/21.
//

import Foundation

struct NewsViewModel {
    let title: String
    private let date: String
    let imageUrl: String
    let url: String
    
    var formattedDate: String {
        return formatDate(from: date) ?? "NA"
    }
    
    init?(news: Article) {
        guard let title = news.title,
              let date = news.publishedAt,
              let imageUrl = news.urlToImage,
              let url = news.url else { return nil }
        self.title = title
        self.date = date
        self.imageUrl = imageUrl
        self.url = url
    }
    
    private func formatDate(from rawDateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let dateks = dateFormatter.date(from: rawDateString) {
            dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
            
            return dateFormatter.string(from: dateks)
        }
        
        return nil
    }
}
