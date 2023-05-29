//
//  TagModel.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/05.
//

import Foundation
import FirebaseFirestoreSwift

struct Tag: Codable {
    @DocumentID var id: String?
    let tagId: Int
    let name: String
}
