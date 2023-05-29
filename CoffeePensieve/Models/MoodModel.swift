//
//  MoodModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/05.
//

import Foundation
import FirebaseFirestoreSwift

struct Mood: Codable {
    @DocumentID var id: String?
    let moodId: Int
    let name: String
    let image: String

}
