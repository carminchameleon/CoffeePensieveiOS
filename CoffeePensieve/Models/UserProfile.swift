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
    @DocumentID var id: String?
    var name: String
    var cups: Int
    var email: String
    
    var morningTime: String
    var nightTime: String
    var limitTime: String
    var reminder: Bool
}


struct UserPreference {
    let cups: Int
    let morningTime: String
    let nightTime: String
    let limitTime: String
    let reminder: Bool
}

struct SignUpForm {
    let email: String
    let password: String
    let name: String

    let cups: Int
    let morningTime: String
    let nightTime: String
    let limitTime: String
    let reminder: Bool
}

struct UploadForm {
    let uid: String
    let email: String
    let name: String
    
    let cups: Int
    let morningTime: String
    let nightTime: String
    let limitTime: String
    let reminder: Bool
}
