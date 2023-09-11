//
//  UpdateModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/05.
//

import Foundation

struct UpdateCell {
    var title: String
    var data: String
}

struct UpdateSection {
    var title: String
    var rowList: [UpdateCell]
}


struct CreatedAtCell {
    var title: String
    var data: Date
}
