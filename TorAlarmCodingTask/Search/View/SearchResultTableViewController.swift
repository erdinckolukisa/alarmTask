//
//  SearchResultTableViewController.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/23/21.
//

import UIKit

class SearchResultTableViewController: UITableViewController {
    
    private var searchViewModel: NewsListViewModel?
    private var searchText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        tableView.register(UINib(nibName: TableViewCellNames.NewsTableViewCell.identifier, bundle: nil),
                               forCellReuseIdentifier: TableViewCellIdentifiers.newsTableViewCell.identifier)
    }
    
    init?(coder: NSCoder, searchViewModel: NewsListViewModel) {
        self.searchViewModel = searchViewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with parameters.")
    }
    
    func bind() {
        searchViewModel?.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel?.numberOfNews ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.newsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell {
            cell.displayNews(searchViewModel?.getNews(at: indexPath.row))
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (searchViewModel?.numberOfNews ?? 0) - 1 {
            searchViewModel?.searchForNews(with: searchText ?? "")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedNewsUrl = searchViewModel?.getNews(at: indexPath.row)?.url {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newsDetailVC = storyboard.instantiateViewController(identifier: StoryboardControllerIdentifiers.newsDetailVC.identifier) { coder in
                return NewsDetailViewController(coder: coder, newsUrl: selectedNewsUrl)
            }
            
            presentingViewController?.navigationController?.pushViewController(newsDetailVC, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchResultTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 0 else { return }
        self.searchText = searchText
        searchViewModel?.searchForNews(with: searchText, reset: true)
    }
}

// MARK: - SearchViewModelDelegate

extension SearchResultTableViewController: NewsListViewModelDelegate {
    func newsDidloaded() {
        tableView.reloadData()
    }
    
    func newsDidFail(with error: NetworkError) {
        showCustomMessageAlert(message: Constants.Errors.genericError, title: "Error") {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
