//
//  ErrorModel.swift
//  TorAlarmCodingTask
//
//  Created by Erdinc Kolukisa on 3/23/21.
//

import Foundation

struct ErrorModel: Decodable {
    var status: String?
    var code: String?
    var message: String?
}
