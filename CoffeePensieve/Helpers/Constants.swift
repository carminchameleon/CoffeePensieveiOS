//
//  Constants.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/29.
//

import UIKit

struct Constant {
    
    struct Web {
        static let about = "https://www.coffeepensieve.com/story"
        static let terms = "https://www.coffeepensieve.com/terms"
        static let policy = "https://www.coffeepensieve.com/privacypolicy"
        static let help = "https://www.coffeepensieve.com/help"
    }
    
    struct FStore {
        static let userCollection = "users"
        static let emailField = "email"
        static let nameField = "name"
        static let cupsField = "cups"
        static let morningTimeField = "morningTime"
        static let nightTimeField = "nightTime"
        static let limitTimeField = "limitTime"
        static let reminderField = "reminder"

        static let drinkCollection = "drinks"
        static let moodCollection = "moods"
        static let tagCollection = "tags"
        
        static let commitCollection = "commits"
        static let uidField = "uid"
        static let createdAtField = "createdAt"
        static let drinkField = "drinkId"
        static let moodField = "moodId"
        static let tagListField = "tagIds"
        static let memoField = "memo"
    }
    
    struct NotificatonMessage {
        static let morningMessage = Message(greeting: "How did you sleep last night", message: "Let's start a new day with a cup of morning coffee.")
        static let nightMessage = Message(greeting: "It's almost time to go to sleep", message: "Take a moment to reflect on your day and preserve your memories in a fancy way")
        static let limitMessage = Message(greeting: "How's your day going so far", message: "Your coffee time is almost up. If you haven't had your coffee yet, now is the perfect time!")

        struct Message {
            let greeting: String
            let message: String
        }
    }
}



struct FontSize {
    static let largeTitle = 34
    static let title1 = 28
    static let title2 = 22
    static let title4 = 20
    static let headline = 17
    static let body = 17
    static let callout = 16
    static let subhead = 15
    static let footnote = 13
    static let caption1 = 12
    static let caption2 = 11
}

struct FontStyle {
    static let largeTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
    static let title1 = UIFont.systemFont(ofSize: 28, weight: .bold)
    static let title2 = UIFont.systemFont(ofSize: 22, weight: .bold)
    static let title3 = UIFont.systemFont(ofSize: 20, weight: .bold)
    static let headline = UIFont.systemFont(ofSize: 17, weight: .bold)
    static let body = UIFont.systemFont(ofSize: 17)
    static let callOut = UIFont.systemFont(ofSize: 16, weight: .light)
    static let subhead = UIFont.systemFont(ofSize: 15, weight: .semibold)
    static let footnote = UIFont.systemFont(ofSize: 12, weight: .bold)
    static let caption1 = UIFont.systemFont(ofSize: 11)

}

struct ContentHeight {
    static let textViewHeight: CGFloat = 48
    static let buttonHeight: CGFloat = 56
}

enum CellId: String {
    case commitCoffeeCell
    case commitMoodCell
    case commitTagCell
    
    case trackerTodayCell
    case trackerGuidlineCell
    case trackerRecordCell
    case trackerLoadingCell
    case trackerGuideLoadingCell
    case trackerRecordLoadingCell
    case trackerRecordEmptyCell
    
    case trackerTodayHeader
    case trackerRecordHeader
    case trackerGuideHeader
    
    case RecordListCell
    case RecordHeaderCell
    
    
    case ProfileCell
    case AccountSettingCell
    case PreferenceNameCell
    case PreferenceCupCell
    case PreferenceTimeCell
    
    
}

// Alert Messgae
