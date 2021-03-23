//
//  StubApi.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/19/21.
//

import Foundation

class StubApi: Networkable {
    
    func getNews(from page: String, category: String, completion: @escaping (Result<Response, NetworkError>) -> Void) {
        readFromStubFile(fileName: "mockPage1") { result in
            completion(result)
        }
    }
    
    func getCategories(completion: @escaping (Result<[Category], NetworkError>) -> Void) {
        readFromStubFile(fileName: "categories") { result in
            completion(result)
        }
    }
    
    func searchNews(with searchKey: String, page: String, completion: @escaping (Result<Response, NetworkError>) -> Void) {
        
    }
    
    private func readFromStubFile<T: Decodable>(fileName: String, completion: @escaping (Result<T, NetworkError>) -> ()) {
        DispatchQueue.main.async {
            if let jsonUrl = Bundle.main.url(forResource: fileName, withExtension: "json") {
                do {
                    let jsonData = try Data(contentsOf: jsonUrl)
                    let decoder = JSONDecoder()
                    let object = try decoder.decode(T.self, from: jsonData)
                    completion(.success(object))
                } catch {
                    completion(.failure(.decodingError))
                }
            } else {
                completion(.failure(.urlError))
            }
        }
    }
}
