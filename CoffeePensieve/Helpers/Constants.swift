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
        static let morningMessage = Message(greeting: "How did you sleep last night",
                                            message: "Let's start a new day with a cup of morning coffee.")
        static let nightMessage = Message(greeting: "It's almost time to go to sleep",
                                          message: "Take a moment to reflect on your day and preserve your memories in a fancy way.")
        static let limitMessage = Message(greeting: "How's your day going so far",
                                          message: "Your coffee time is almost up. If you haven't had your coffee yet, now is the perfect time!")
        struct Message {
            let greeting: String
            let message: String
        }
    }
    
    static var morningGreeting: String {
        return morningGreetingList.randomElement()!
    }
    
    static var afternoonGreeting: String {
        return afternoonGreetingList.randomElement()!
    }
    
    static var eveningGreeting: String {
        return eveningGreetingList.randomElement()!
    }
    
    static let morningGreetingList: [String] = [
        "I hope you had a good night’s sleep",
        "I hope you woke up feeling refreshed",
        "I hope you had sweet dreams",
        "The world is waiting for you.",
        "sleepyhead! Let's conquer the day together.",
        "Sending positive vibes your way.",
        "May your morning be as wonderful as you are.",
        "Here's to a new day full of endless possibilities.",
    ]
    
    static let afternoonGreetingList = [
        "I hope you end your day on a high note",
        "How has your day been so far?",
        "Wishing you a great afternoon ahead.",
        "May your day be filled with\n productivity and success.",
        "May your day be filled with\n joy and productivity.",
        "how's your day going?\n Hope it's been great so far.",
        "Keep up the good workn you're doing great!",
        "May your morning be as wonderful as you are.",
        "May the rest of your day be \nas awesome as you are.",
        "Wishing you a peaceful and \nstress-free afternoon.",
        "Remember to take a break and \nenjoy the little things in life."
    ]
    
    static let eveningGreetingList = [
        "I hope your evening is filled\n with laughter and joy",
        "I hope you have a restful and rejuvenating night",
        "I hope you have a delicious dinner \nand a wonderful evening",
        "Sleep well and sweet dreams",
        "I hope you wake up feeling refreshed\n and ready for a new day",
        "I wish you a peaceful and restful night",
        "Wishing you a relaxing and enjoyable evening.",
        "May your night be filled \nwith peace and tranquility.",
        "Hope you had a good day and\n are looking forward to a great evening.",
        "Take a deep breath and let go\n of any stress from the day.",
        "May your evening be filled with\n laughter and good company.",
        "Remember to take some time for yourself\n and do something you enjoy.",
        "Wishing you a night full of \nsweet dreams and happy thoughts.",
        "Hope you have a chance to unwind \nand recharge before the day is over.",
        "May your evening be as wonderful as you are."
    ]
    
    static let drinkList: [Drink] = [
        Drink(isIced: false, drinkId: 0, name: "Americano", image: "Drink_Americano"),
        Drink(isIced: false, drinkId: 1, name: "Latte", image: "Drink_Latte"),
        Drink(isIced: false, drinkId: 2, name: "Cappuccino", image: "Drink_Cappuccino"),
        Drink(isIced: false, drinkId: 3, name: "Flatwhite", image: "Drink_Flatwhite"),
        Drink(isIced: false, drinkId: 4, name: "Mocha", image: "Drink_Mocha"),
        Drink(isIced: false, drinkId: 5, name: "Filter", image: "Drink_Filter"),
        Drink(isIced: true, drinkId: 50, name: "Americano", image: "Drink_IcedAmericano"),
        Drink(isIced: true, drinkId: 51, name: "Latte", image: "Drink_IcedLatte"),
        Drink(isIced: true, drinkId: 52, name: "Mocha", image: "Drink_IcedMocha"),
        Drink(isIced: true, drinkId: 53, name: "Cold brew", image: "Drink_Coldbrew"),
        Drink(isIced: false, drinkId: 6, name: "Espresso", image: "Drink_Espresso"),
        Drink(isIced: false, drinkId: 7, name: "Macchiato", image: "Drink_Macchiato")]
    
    static let moodList: [Mood] = [
        Mood(moodId: 0, name: "Happy", image: "😊"),
        Mood(moodId: 1, name: "Excited", image: "🥳"),
        Mood(moodId: 2, name: "Grateful", image: "🥰"),
        Mood(moodId: 3, name: "Relaxed", image: "😌"),
        Mood(moodId: 4, name: "Tired", image: "🫠"),
        Mood(moodId: 5, name: "Anxious", image: "🥺"),
        Mood(moodId: 6, name: "Angry",image: "🤬"),
        Mood(moodId: 7, name: "Sad", image: "😥"),
        Mood(moodId: 8, name: "Stressed", image: "🤯")]
    
    static let tagList: [Tag] = [
        Tag(tagId: 0, name: "Refreshing"),
        Tag(tagId: 1, name: "Morning"),
        Tag(tagId: 2, name: "Concentrating"),
        Tag(tagId: 3, name: "Socializing"),
        Tag(tagId: 4, name: "Working out"),
        Tag(tagId: 5, name: "Chilling"),
        Tag(tagId: 6, name: "Lunch"),
        Tag(tagId: 7, name: "Dinner")]
}

// MARK: - Contents height for calculation
struct ContentHeight {
    static let textViewHeight: CGFloat = 48
    static let buttonHeight: CGFloat = 56
    static let authButtonHeight: CGFloat = 50
}

// MARK: - Cell Id
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
    case PreferenceNameCell
    case PreferenceCupCell
    case PreferenceTimeCell
    
    case updateCell
    case updateHeaderCell
    case noteCell
    case tagCell
}

