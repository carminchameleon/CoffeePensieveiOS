//
//  Constants.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/29.
//

import UIKit

struct Constant {
    struct FStore {
        static let userCollection = "users"
        static let emailField = "email"
        static let nameField = "name"
        static let cupsField = "cups"
        static let morningTimeField = "morningTime"
        static let nightTimeField = "nightTime"
        static let limitTimeField = "limitTime"
        static let morningReminderField = "morningReminder"
        static let nightReminderField = "nightReminder"
        static let limitReminderField = "limitReminder"
    }
}


//
//struct FontSize: CGFont {
//    static let largeTitle = 34
//    static let title1 = 28
//    static let title2 = 22
//    static let title4 = 20
//    static let headline = 17
//    static let body = 17
//    static let callout = 16
//    static let subhead = 15
//    static let footnote = 13
//    static let caption1 = 12
//    static let caption2 = 11
//}

struct FontStyle {
    static let largeTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
    static let title1 = UIFont.systemFont(ofSize: 28)
    static let title2 = UIFont.systemFont(ofSize: 22)
    static let title3 = UIFont.systemFont(ofSize: 20)
    static let headline = UIFont.systemFont(ofSize: 17, weight: .bold)
    static let body = UIFont.systemFont(ofSize: 17)
    static let callOut = UIFont.systemFont(ofSize: 16)
    static let subhead = UIFont.systemFont(ofSize: 15)
    static let footnote = UIFont.systemFont(ofSize: 12)
    static let caption1 = UIFont.systemFont(ofSize: 11)

}
