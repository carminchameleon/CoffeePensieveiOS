//
//  LocalNotification.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/04.
//

import UIKit

final class LocalNotification {
    
    static let shared = LocalNotification()
    private init() {}

    static let sharedNotiCenter = UNUserNotificationCenter.current()
    
    static func setNotification(type: PreferenceTime, timeString: String) {
        self.sharedNotiCenter.removeAllDeliveredNotifications()
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
        
        sharedNotiCenter.add(request) {(error) in
            if let error = error {
                print("Local Push Alert setting Fail", error.localizedDescription)
            }
        }
    }
    
    
    static func removeNotification(){
        sharedNotiCenter.removePendingNotificationRequests(withIdentifiers: [PreferenceTime.morning.rawValue,
                                                                             PreferenceTime.night.rawValue,
                                                                             PreferenceTime.limit.rawValue])
    }

}
