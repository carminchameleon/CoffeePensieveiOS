//
//  Common.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/30.
//

import UIKit

class Common {
    
    enum UserDefaultsKey: String {
        case userId
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
    
    static func setUserDefaults(_ value: Any?, forKey defaultsKey: UserDefaultsKey) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: defaultsKey.rawValue)
    }
    
    static func removeUserDefaultsObject(forKey defaultskey: UserDefaultsKey) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: defaultskey.rawValue)
    }
    
    static func changeDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "En")
        dateFormatter.dateFormat = "EEEE, YYYY MMMM d 'at' h:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    // 시간설정 절대적으로 바꿔줌
    // 오후 1시 -> 13:00
    // 오전 1시 -> 01:00
    static func getTimeToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
    
    static func getDetailStringTime(time: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "HH:mm"

        guard let date = dateFormatter.date(from: time) else { return nil }
            dateFormatter.dateFormat = "h:mm a"
            let formattedTime = dateFormatter.string(from: date)
            return formattedTime
        }
        
}
