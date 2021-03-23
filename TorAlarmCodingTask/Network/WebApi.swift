//
//  WebApi.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/19/21.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case decodingError
    case responseError(message: String)
}

class WebApi: Networkable {
    private var urlComponents = URLComponents()
    private let apiKey = "98ad516f84bd490e8061feacb43979aa"
    private var queryItems: [URLQueryItem] = [URLQueryItem]()

    lazy var defaultQueryItems: [URLQueryItem] = {
        var queryItems: [URLQueryItem] = [URLQueryItem]()
        let queryItemApiKey = URLQueryItem(name: "apikey", value: apiKey)
        queryItems.append(queryItemApiKey)
        
        return queryItems
    }()
    
    init() {
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2/top-headlines"
    }
    
    func getNews(from page: String, category: String, completion: @escaping(Result<Response, NetworkError>) -> Void) {
        var queryItems: [URLQueryItem] = [URLQueryItem]()
        queryItems.append(contentsOf: defaultQueryItems)
        let queryItemCategory = URLQueryItem(name: "category", value: category)
        let queryItemPageNumber = URLQueryItem(name: "page", value: page)
        let queryItemPageSize = URLQueryItem(name: "pagesize", value: "10")
        let queryItemCountryCode = URLQueryItem(name: "country", value: "de")
        queryItems.append(queryItemCategory)
        queryItems.append(queryItemPageNumber)
        queryItems.append(queryItemPageSize)
        queryItems.append(queryItemCountryCode)
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(.urlError))
            
            return
        }
        
        let request = URLRequest(url: url)
        sendData(request: request) { result in
            completion(result)
        }
    }
    
    func getCategories(completion: @escaping (Result<[Category], NetworkError>) -> Void) {
        // I couldn't implement this method.
        // As I mentioned in README.md file the API don't support a categories endpoint.
        // That is why I implemented that feature locally
        
    }
    
    func searchNews(with searchKey: String, page: String, completion: @escaping (Result<Response, NetworkError>) -> Void) {
        urlComponents.path = "/v2/everything"
        var queryItems: [URLQueryItem] = [URLQueryItem]()
        queryItems.append(contentsOf: defaultQueryItems)
        let queryItemSearch = URLQueryItem(name: "q", value: searchKey)
        let queryItemPageNumber = URLQueryItem(name: "page", value: page)
        queryItems.append(queryItemSearch)
        queryItems.append(queryItemPageNumber)
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(.urlError))
            
            return
        }
        
        let request = URLRequest(url: url)
        sendData(request: request) { result in
            completion(result)
        }
    }
    
    private func sendData<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> ()) {
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                if (error != nil) {
                    completion(.failure(.responseError(message: error?.localizedDescription ?? Constants.Errors.genericError)))
                    
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.responseError(message: error?.localizedDescription ?? Constants.Errors.genericError)))
                    
                    return
                }
                
                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(model))
                    
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
