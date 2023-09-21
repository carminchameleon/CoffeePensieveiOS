//
//  Common.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/30.
//

import UIKit

final class Common {
    
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
    static func removeAllUserDefaultObject() {
        let keys = Array(UserDefaults.standard.dictionaryRepresentation().keys)
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    static func changeDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "En")
        dateFormatter.dateFormat = "EEEE, YYYY MMMM d 'at' h:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat{
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
    
    // MARK: - 음료 텍스트로 보여주는 것
    static func getDrinkText(_ drink: Drink) -> String {
        let drinkName = drink.name.uppercased()
        let tempMode = drink.isIced ? "ICED" : "HOT"
        return "\(tempMode) \(drinkName)"
    }
    
    static func getMoodText(_ mood: Mood) -> String {
        return "\(mood.image) \(mood.name.uppercased())"
    }
    
    static func getTagText(_ tagList: [Tag]) -> String {
        var result = ""
        
        tagList.forEach { tag in
            result.append(contentsOf: "#\(tag.name) ")
        }
        return result
    }
    
    // 모달 사이즈 중간으로 맞추기
    static func resizeModalController(modalVC: UIViewController, size: Double = 0.4) {
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [ .custom(identifier: .medium) { context in size * context.maximumDetentValue },
                              .medium() ]
        }
    }
    
    static func getGreetingSentenceByTime() -> String? {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let date = dateFormatter.string(from: nowDate)
        let currentTime = Int(date)!
        
        switch currentTime {
        case 0...12 :
            return Constant.morningGreeting
        case 12...17 :
            return Constant.afternoonGreeting
        default:
            return Constant.eveningGreeting
        }
    }
    
    
    // record list view에 들어가는 데이터 변환 함수
    // [2023-08-29 14:00:00 +0000: [commit, commit...]
    typealias SortedDailyDetailedCommit = [Date: [CommitDetail]]
    static func sortDetailedCommitwithCreatedAt(_ commitList: [CommitDetail]) -> SortedDailyDetailedCommit {
        var groupedCommitDetails = [Date: [CommitDetail]]()
        for commitDetail in commitList {
            let date = Calendar.current.startOfDay(for: commitDetail.createdAt)
            if var group = groupedCommitDetails[date] {
                group.append(commitDetail)
                groupedCommitDetails[date] = group
            } else {
                groupedCommitDetails[date] = [commitDetail]
            }
        }
        return groupedCommitDetails
    }
    
    // commit 있을 때 그 commit의 해당 데이터들을 묶어줘서 CommitDetail로 만들어주는
    static func getCommitDetailInfo(commit: Commit) -> CommitDetail {
        let drink = Constant.drinkList.filter { $0.drinkId == commit.drinkId }[0]
        let mood = Constant.moodList.filter { $0.moodId == commit.moodId }[0]
        var tags: [Tag] = []
        
        commit.tagIds.forEach { tagId in
            let findedTag = Constant.tagList.filter { $0.tagId == tagId}
            if !findedTag.isEmpty {
                tags.append(findedTag[0])
            }
        }

        let commitDatil = CommitDetail(id: commit.id,
                                       uid: commit.uid,
                                       drink: drink,
                                       mood: mood,
                                       tagList: tags,
                                       memo: commit.memo,
                                       createdAt: commit.createdAt)
        return commitDatil
    }
    
    // 제일 많이 마신 음료수 뽑기
    static func getTopDrinkList(commitList: [Commit]) {
        var drinkCount: [Int: Int] = [:]
        commitList.forEach { commit in
            if let number  = drinkCount[commit.drinkId] {
                drinkCount[commit.drinkId] = number + 1
            } else {
                drinkCount[commit.drinkId] = 1
            }
        }
        let sortedData =  drinkCount.sorted { $0.value > $1.value }
        var index = 0
        let drinkData = sortedData.map { (key: Int, value: Int) in
            let drink = Constant.drinkList.filter { $0.drinkId == key }[0]
            index = index + 1
            return DrinkRanking(ranking: index, drink: drink, number: value)
        }
        let _ = drinkData[0...2]
    }
}
