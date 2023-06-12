//
//  Common.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/30.
//

import UIKit

class Common {

    // 이메일 검증 로직
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    // 비밀번호 검증 로직
    /*
     최소 8자리 이상 /
     영어 대문자, 소문자 또는 숫자 중 하나 이상 포함 /
     특수문자 (@, $, !, %, *, #, ?, &)를 포함할 수 있지만 필수는 아님
     */
    static func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d@$!%*#?&]{8,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    static let notiCenter = DataManager.sharedNotiCenter
    
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
    
    
    
    
    
    static func getGreetingSentenceByTime() -> String? {
        let morningGreeting:[String] = [
            "I hope you had a good night’s sleep",
            "I hope you woke up feeling refreshed",
            "I hope you had sweet dreams",
            "The world is waiting for you.",
            "sleepyhead! Let's conquer the day together.",
            "Sending positive vibes your way.",
            "May your morning be as wonderful as you are.",
            "Here's to a new day full of endless possibilities.",
        ]
        
        let afternoonGreeting = [
            "I hope you end your day on a high note",
            "How has your day been so far?",
            "Wishing you a great afternoon ahead.",
            "May your day be filled with\n productivity and success.",
            "May your day be filled with\n joy and productivity.",
            "how's your day going?\n Hope it's been great so far.",
            "Keep up the good workn you're doing great!",
            "May your morning be as wonderful as you are.",
            "May the rest of your day be \nas awesome as you are.",
            "Wishing you a peaceful and \nstress-free afternoon.",
            "Remember to take a break and \nenjoy the little things in life."
        ]
        
        let eveningGreeting = [
            "I hope your evening is filled\n with laughter and joy",
            "I hope you have a restful and rejuvenating night",
            "I hope you have a delicious dinner \nand a wonderful evening",
            "Sleep well and sweet dreams",
            "I hope you wake up feeling refreshed\n and ready for a new day",
            "I wish you a peaceful and restful night",
            "Wishing you a relaxing and enjoyable evening.",
            "May your night be filled \nwith peace and tranquility.",
            "Hope you had a good day and\n are looking forward to a great evening.",
            "Take a deep breath and let go\n of any stress from the day.",
            "May your evening be filled with\n laughter and good company.",
            "Remember to take some time for yourself\n and do something you enjoy.",
            "Wishing you a night full of \nsweet dreams and happy thoughts.",
            "Hope you have a chance to unwind \nand recharge before the day is over.",
            "May your evening be as wonderful as you are."
        ]
        
        
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let date = dateFormatter.string(from: nowDate)// 현재 시간의 Date를 format에 맞춰 string으로 반환
        let currentTime = Int(date)!
        switch currentTime {
        case 0...12 :
            return morningGreeting.randomElement()
        case 12...17 :
            return afternoonGreeting.randomElement()
        default:
            return eveningGreeting.randomElement()
        }
    }
    
    
    static func setNotification(type: PreferenceTime, timeString: String) {
        self.notiCenter.removeAllDeliveredNotifications()
        // 요청 시간 처리
        let component = timeString.components(separatedBy: ":")
        let hour = Int(component[0]) ?? 0
        let minute = Int(component[1]) ?? 0
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let isDaily = true
        
        var title = ""
        var body = ""
        // 각 타입에 맞는 텍스트 등록
        switch type {
        case .morning:
            title = Constant.NotificatonMessage.morningMessage.greeting
            body = Constant.NotificatonMessage.morningMessage.message
        case .night:
            title = Constant.NotificatonMessage.nightMessage.greeting
            body = Constant.NotificatonMessage.nightMessage.message
        case .limit:
            title = Constant.NotificatonMessage.limitMessage.greeting
            body = Constant.NotificatonMessage.limitMessage.message
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: type.rawValue, content: content, trigger: trigger)
        
        notiCenter.add(request) {(error) in
            if let error = error {
                print("Local Push Alert setting Fail", error.localizedDescription)
            }
        }
    }
    
    static func removeNotification(){
        notiCenter.removePendingNotificationRequests(withIdentifiers: [PreferenceTime.morning.rawValue,
                                                                       PreferenceTime.night.rawValue,
                                                                       PreferenceTime.limit.rawValue ])
    }
    
}
