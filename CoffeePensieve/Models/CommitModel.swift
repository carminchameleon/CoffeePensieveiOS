//
//  CommitModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/07.
//

import UIKit
import FirebaseFirestoreSwift

struct Commit: Codable {
    var id: String
    var uid: String
    let drinkId: Int
    let moodId: Int
    let tagIds: [Int]
    let memo: String
    let createdAt: Date

}

struct CommitDetail {
    var id: String
    var uid: String
    var drink: Drink
    var mood: Mood
    var tagList: [Tag]
    var memo: String
    var createdAt: Date
}

struct CommitResultDetail {
    var drinkId: Int
    var moodId: Int
    var tagIds: [Int] = []
    var memo: String = ""
    var createdAt: Date = Date()

    
    init(drinkId: Int, moodId: Int, tagIds: [Int], memo: String, createdAt: Date) {
        self.drinkId = drinkId
        self.moodId = moodId
        self.tagIds = tagIds
        self.memo = memo
        self.createdAt = createdAt
    }

    
    var createdAtString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "En") // 사용자 지정 로케일 설정 (한국어)
        dateFormatter.dateFormat = "EEEE, MMMM d 'at' h:mm a"
        let dateString = dateFormatter.string(from: createdAt)
        return dateString
    }
    
    var drinkLabelString: String {
        var result = ""
        let selectedDrink = Constant.drinkList.filter { $0.drinkId == drinkId }
        if !selectedDrink.isEmpty {
            let drink = selectedDrink[0]
            let tempMode = drink.isIced ? "🧊ICED" : "🔥HOT"
            result = "\(tempMode) / \(drink.name)"
        }
        return result
    }
    
    var drinkImage: UIImage? {
        let selectedDrink = Constant.drinkList.filter { $0.drinkId == drinkId }
        if !selectedDrink.isEmpty {
            let drink = selectedDrink[0]
            return UIImage(named: drink.image)
        } else {
            return nil
        }
    }
    
    var moodNameString: String {
        let mood = Constant.moodList.filter { $0.moodId == moodId }[0]
        return mood.name
    }
    
    var moodImageString: String {
        let mood = Constant.moodList.filter { $0.moodId == moodId }[0]
        return mood.image
    }
    
    var tagString: String {
        var tagText = ""
        let allTagList = Constant.tagList
        tagIds.forEach { tagId in
            let findedTag = allTagList.filter { $0.tagId == tagId }
            if !findedTag.isEmpty {
                let tag = findedTag[0].name
                tagText.append("#\(tag) ")
            }
        }
        return tagText
    }

    
}
