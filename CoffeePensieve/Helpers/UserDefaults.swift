//
//  UserDefaults.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/08/09.
//

import Foundation

class UserDefaultsManager {
 
    enum UserDefaultsKey: String {
        case userId
        case name
        case email
        // preference
        case cups
        case morningTime
        case nightTime
        case limitTime
        case reminder
    }
 
    // forKey 넣으면 해당되는 값을 반환
    static func getUserDefaultsObject(forKey defaultsKey: UserDefaultsKey) -> Any? {
        let userDefaults = UserDefaults.standard
        
        if let object = userDefaults.object(forKey: defaultsKey.rawValue) {
            return object
        } else {
            return nil
        }
    }
    //  설정하기
    static func setUserDefaults(_ value: Any?, forKey defaultsKey: UserDefaultsKey) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: defaultsKey.rawValue)
    }
    // 설정된 값 지우기
    static func removeUserDefaultsObject(forKey defaultskey: UserDefaultsKey) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: defaultskey.rawValue)
    }
    // userDefaults에 있는 값 전부 삭제하기
    static func removeAllUserDefaultObject() {
        let keys = Array(UserDefaults.standard.dictionaryRepresentation().keys)
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
