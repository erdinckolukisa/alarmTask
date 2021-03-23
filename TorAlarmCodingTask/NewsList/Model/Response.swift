//
//  Response.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/19/21.
//

import Foundation

struct Response: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}
