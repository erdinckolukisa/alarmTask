//
//  NewsListViewModel.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/19/21.
//

import Foundation

protocol NewsListViewModelDelegate: class {
    func newsDidloaded()
    func newsDidFail(with error: NetworkError)
}

class NewsListViewModel {
    
    private let network: Networkable
    private var news: [NewsViewModel] = []
    private var currentPage = 1
    private var isLoading = false
    private var canLoadMore = true
    private var workItem: DispatchWorkItem?
    weak var delegate: NewsListViewModelDelegate?
    
    var numberOfNews: Int {
        return news.count
    }
    
    var lastElementIndex: Int {
        return news.endIndex
    }
    
    init(network: Networkable) {
        self.network = network
    }
    
    func getNews(at index: Int) -> NewsViewModel? {
        return news[index]
    }
    
    //MARK: - LoadNews
    
    func loadNews(category: String, reset: Bool = false) {
       
        checkLoadingStatus(shouldReset: reset)
        
        network.getNews(from: "\(currentPage)", category: category) { [weak self] result in
            self?.handleResponse(with: result)
            self?.isLoading = false
        }
    }
    
    //MARK: - SearhNews
    
    func searchForNews(with searchKey: String, reset: Bool = false) {
        
        workItem?.cancel()
        workItem = DispatchWorkItem { [weak self] in
            
            if (self?.workItem?.isCancelled) != nil {
                return
            }
            
            self?.checkLoadingStatus(shouldReset: reset)
            
            let currentPageNumber = self?.currentPage ?? 1
            self?.network.searchNews(with: searchKey, page: "\(currentPageNumber)", completion: {[weak self] response in
                self?.handleResponse(with: response)
                self?.isLoading = false
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem!)
    }
    
    //MARK: - HandleResponse
    
    private func handleResponse(with response: Result<Response, NetworkError>) {
        switch response {
        case .failure(let error):
            delegate?.newsDidFail(with: error)
            
        case .success(let response):
            let loadedNews = response.articles?.compactMap{ NewsViewModel(news: $0) }
            currentPage += 1
            news.append(contentsOf: loadedNews ?? [])
            
            if numberOfNews >= response.totalResults ?? 0 {
                canLoadMore = false
            }
            
            delegate?.newsDidloaded()
        }
    }
    
    // MARK: - CheckLoadingStatus
    
    private func checkLoadingStatus(shouldReset: Bool) {
      
        if shouldReset {
            resetState()
            delegate?.newsDidloaded()
        }
        
        if canLoadMore == false || isLoading == true {
            return
        }
        isLoading = true
    }
    
    //MARK: - ResetState
    
    private func resetState() {
        currentPage = 1
        canLoadMore = true
        news.removeAll()
    }
}
