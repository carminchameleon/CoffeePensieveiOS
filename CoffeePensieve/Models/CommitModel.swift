//
//  CommitModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/07.
//

import Foundation
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
    let drink: Drink
    let mood: Mood
    let tagList: [Tag]
    let memo: String
    let createdAt: Date
}
