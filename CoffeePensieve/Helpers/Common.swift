//
//  Common.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/30.
//

import Foundation

class Common {
    
    enum UserDefaultsKey: String {
        case userId
    }
    
    // forKey 넣으면 해당되는 값을 반환
    static func getUserDefaultsObject(forKey defaultsKey: UserDefaultsKey) -> Any? {
        let userDefaults = UserDefaults.standard
        
        if let object = userDefaults.object(forKey: defaultsKey.rawValue) {
            print(object)
            return object
        } else {
            return nil
        }
    }
    
    static func setUserDefaults(_ value: Any?, forKey defaultsKey: UserDefaultsKey) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: defaultsKey.rawValue)
    }
    
    static func removeUserDefaultsObject(forKey defaultskey: UserDefaultsKey) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: defaultskey.rawValue)
    }
    
    
    
}
