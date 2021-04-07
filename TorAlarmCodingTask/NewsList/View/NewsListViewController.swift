//
//  NewsListViewController.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/19/21.
//

import UIKit

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    private var newsListViewModel: NewsListViewModel?
    private let refreshControl = UIRefreshControl()
    
    var network: Networkable?
    var newsCategory: String?
    
    init?(coder: NSCoder, newsListViewModel: NewsListViewModel, newsCategory: String) {
        self.newsListViewModel = newsListViewModel
        self.newsCategory = newsCategory
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with parameters.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        prepareViewModel()
        prepareNavigationBar()
        
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        newsTableView.refreshControl = refreshControl
    }
    
    private func prepareTableView() {
        newsTableView.register(UINib(nibName: TableViewCellNames.NewsTableViewCell.identifier, bundle: nil),
                               forCellReuseIdentifier: TableViewCellIdentifiers.newsTableViewCell.identifier)
    }
    
    private func prepareViewModel() {
        newsListViewModel?.delegate = self
        if let category = newsCategory {
            newsListViewModel?.loadNews(category: category, reset: true)
        }
    }
    
    @objc private func reloadData(_ refreshControl: UIRefreshControl) {
        if let category = newsCategory {
            newsListViewModel?.loadNews(category: category, reset: true)
        }
    }
}

// MARK: TableViewDataSource

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsListViewModel?.numberOfNews ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.newsTableViewCell.identifier) as? NewsTableViewCell
        if let newsCell = cell {
            newsCell.displayNews(newsListViewModel?.getNews(at: indexPath.row))
            return newsCell
        }
        return NewsTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (newsListViewModel?.numberOfNews ?? 0) - 1 {
            if let newsCategory = newsCategory {
                newsListViewModel?.loadNews(category: newsCategory)
            }
        }
    }
}

// MARK: TableViewDelegate

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedNewsUrl = newsListViewModel?.getNews(at: indexPath.row)?.url {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newsDetailVC = storyboard.instantiateViewController(identifier: StoryboardControllerIdentifiers.newsDetailVC.identifier) { coder in
                return NewsDetailViewController(coder: coder, newsUrl: selectedNewsUrl)
            }
            
            navigationController?.pushViewController(newsDetailVC, animated: true)
        }
    }
}

// MARK: NewsListViewModelDelegate

extension NewsListViewController: NewsListViewModelDelegate {
    func newsDidFail(with error: NetworkError) {
        var errorMessage = ""
        switch error {
        case .responseError(let message):
            errorMessage = message
        default:
            errorMessage = Constants.Errors.genericError
        }
        
        showCustomMessageAlert(message: errorMessage, title: "Error") {
            
        }
    }
    
    func newsDidloaded() {
        refreshControl.endRefreshing()
        newsTableView.reloadData()
    }
}
