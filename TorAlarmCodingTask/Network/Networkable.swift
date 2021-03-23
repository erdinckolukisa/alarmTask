//
//  Networkable.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/19/21.
//

import Foundation

protocol Networkable {
    func getNews(from page: String, category: String, completion: @escaping(Result<Response, NetworkError>) -> Void)
    func getCategories(completion: @escaping (Result<[Category], NetworkError>) -> Void)
    func searchNews(with searchKey: String, page: String, completion: @escaping (Result<Response, NetworkError>) -> Void)
}
