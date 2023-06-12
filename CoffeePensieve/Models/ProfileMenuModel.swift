//
//  ProfileMenuModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/23.
//

import Foundation

struct ProfileMenu {
    var type: Menu
    var title: String
    var icon: String
}

enum Menu: String {
    case profile
    case preference
    case delete
    case support
    case term
    case policy
    case about
    case logout
}
