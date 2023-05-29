//
//  RecordSummaryModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/14.
//

import Foundation

struct RecordSummary: Codable {
    let total: Int
    let weekly: Int
    let monthly: Int
    let yearly: Int
}
