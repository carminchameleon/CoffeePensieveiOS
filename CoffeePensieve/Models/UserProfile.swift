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

// MARK: - Section Heading
// TODO: - add To do
///
/**
 - Description: 숫자 단위 요약
 - Parameters:
 - a: 더할 첫 번째 정수
 - b: 더할 두 번째 정수
 - Returns: 두 정수의 합
 - Example
 formatNumber(1204) // 1,204
 **/

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
