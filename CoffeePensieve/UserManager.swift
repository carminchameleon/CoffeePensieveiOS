//
//  UserManager.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/18.
//
final class UserManager {
    static let shared = UserManager()
    private init() {}

    var isLoggedIn: Bool = false
    var username: String?
    var email: String?
    // 다른 데이터 필드

    func login(username: String, password: String) {
        // 로그인 로직
        isLoggedIn = true
        self.username = username
        self.email = "user@example.com"
        // 다른 데이터 필드 업데이트
    }

    func logout() {
        // 로그아웃 로직
        isLoggedIn = false
        self.username = nil
        self.email = nil
        // 다른 데이터 필드 업데이트
    }
}
