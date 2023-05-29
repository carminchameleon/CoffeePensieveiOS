//
//  PreferenceModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/26.
//

import Foundation

struct Preference {
    let sectionTitle: String
    var rowList: [PreferenceCell]
}

struct PreferenceCell {
    var title: String
    var icon: String
    var data: String
}

