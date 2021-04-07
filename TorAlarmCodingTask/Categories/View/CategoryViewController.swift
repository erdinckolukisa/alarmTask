//
//  CategoryViewController.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/20/21.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    private let categoryListViewModel = CategoryListViewModel(network: StubApi())
    private var searchText: String?
    private var searchController: UISearchController?
    private var searchResultTableViewController: SearchResultTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViewModel()
        prepareTableView()
        prepareNavigationBar()
        configureSearchBar()
    }
    
    private func initializeViewModel() {
        categoryListViewModel.delegate = self
        categoryListViewModel.getCategories()
    }
    
    private func prepareTableView() {
        categoriesTableView.register(UINib(nibName: TableViewCellNames.CategoryTableViewCell.identifier, bundle: nil),
                                     forCellReuseIdentifier: TableViewCellIdentifiers.categoryTableViewCell.identifier)
    }
}
 
// MARK: CategoriesDownloadedDelegate

extension CategoryViewController: CategoryListViewModelProtocol {
    func categoriesDidLoad() {
        categoriesTableView.reloadData()
        categoriesTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func categoriesDidFail(with error: NetworkError) {
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
}

// MARK: UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryListViewModel.numberOfCategories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.categoryTableViewCell.identifier) as? CategoryTableViewCell
        if let categoryCell = categoryCell {
            categoryCell.displayCategoryInfo(category: categoryListViewModel.getCategory(at: indexPath.row))
            
            return categoryCell
        }
        
        return CategoryTableViewCell()
    }
}

// MARK: UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedCategoryId = categoryListViewModel.getCategory(at: indexPath.row)?.id {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newsViewController = storyboard.instantiateViewController(identifier: StoryboardControllerIdentifiers.newsListVC.identifier, creator: { coder in
                return NewsListViewController(coder: coder, newsListViewModel: NewsListViewModel(network: WebApi()), newsCategory: selectedCategoryId)
            })
            
            navigationController?.pushViewController(newsViewController, animated: true)
        }
    }
}


extension CategoryViewController: UISearchControllerDelegate {
    func configureSearchBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        searchResultTableViewController = storyboard.instantiateViewController(identifier: StoryboardControllerIdentifiers.searchResultVC.identifier, creator: { coder in
            return SearchResultTableViewController(coder: coder, searchViewModel: NewsListViewModel(network: WebApi()))
        })
        searchController = UISearchController(searchResultsController: searchResultTableViewController)
        searchController?.delegate = self
        searchController?.searchResultsUpdater = searchResultTableViewController
        definesPresentationContext = true
        searchController?.loadViewIfNeeded()
        searchController?.searchBar.delegate = searchResultTableViewController
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.placeholder = "Type something to search news"
        searchController?.searchBar.tintColor = UIColor.appAccentColor
        searchController?.searchBar.backgroundColor = UIColor.white
        navigationItem.titleView = searchController?.searchBar
    }
}
