//
//  NewsDetailViewController.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/21/21.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var browser: WKWebView!
    
    var newsUrl: String?
    
    init?(coder: NSCoder, newsUrl: String) {
        self.newsUrl = newsUrl
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with parameter.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBar()
        displayNews()
    }
    
    private func displayNews() {
        if let newsUrl = newsUrl, let url = URL(string: newsUrl) {
            browser.load(URLRequest(url: url))
        }
    }
}
