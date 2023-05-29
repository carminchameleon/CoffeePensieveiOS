//
//  GuidelineModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/14.
//

import Foundation

struct Guideline: Codable {
    let limitTime: String
    let limitCup: Int
    let currentCup: Int
}
