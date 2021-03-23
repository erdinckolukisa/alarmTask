//
//  CategoryViewModel.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/20/21.
//

import Foundation

protocol CategoryListViewModelProtocol: class {
    func categoriesDidLoad()
    func categoriesDidFail(with error: NetworkError)
}

class CategoryListViewModel {
    
    private var categories: [CategoryViewModel]?
    private let network:Networkable?
    weak var delegate: CategoryListViewModelProtocol?
    
    init(network: Networkable) {
        self.network = network
    }
    
    var numberOfCategories: Int {
        return categories?.count ?? 0
    }
    
    func getCategories() {
        network?.getCategories{ [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories.compactMap{ CategoryViewModel(category: $0) }
                self?.delegate?.categoriesDidLoad()
                
            case .failure(let error):
                self?.delegate?.categoriesDidFail(with: error)
            }
        }
    }
    
    func getCategory(at index: Int) -> CategoryViewModel? {
        return categories?[index]
    }
}
