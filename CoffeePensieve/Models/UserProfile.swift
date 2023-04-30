//
//  UserInfo.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/29.
//

import UIKit

import FirebaseFirestoreSwift

// 데이터 받아오는 유저 프로필
struct UserProfile: Codable {
    var name: String?
    var cups: Int?
    var email: String?
    
    var morningTime: String?
    var nightTime: String?
    var limitTime: String?
    
    var morningReminder: Bool?
    var nightReminder: Bool?
    var limitReminder: Bool?
}

