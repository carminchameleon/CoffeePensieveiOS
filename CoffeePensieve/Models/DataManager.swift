//
//  DataManager.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/06.
//

import Foundation
import Firebase
// 모든 데이터를 관리하는 매니저
final class DataManager {
    static let sharedNotiCenter = UNUserNotificationCenter.current()

    static let shared = DataManager()
    
    private let commitManager = CommitNetworkManager.shared
    private let authManager = AuthNetworkManager.shared
    private let trackerManager = TrackerNetworkManager.shared

    
    // 음료 리스트 무드 리스트 태그 리스트
    private let drinkList: [Drink] = [
                                    Drink(isIced: false, drinkId: 0, name: "Americano", image: "Drink_Americano"),
                                    Drink(isIced: false, drinkId: 1, name: "Latte", image: "Drink_Latte"),
                                    Drink(isIced: false, drinkId: 2, name: "Cappuccino", image: "Drink_Cappuccino"),
                                    Drink(isIced: false, drinkId: 3, name: "Flatwhite", image: "Drink_Flatwhite"),
                                    Drink(isIced: false, drinkId: 4, name: "Mocha", image: "Drink_Mocha"),
                                    Drink(isIced: false, drinkId: 5, name: "Filter", image: "Drink_Filter"),
                                    Drink(isIced: true, drinkId: 50, name: "Americano", image: "Drink_IcedAmericano"),
                                    Drink(isIced: true, drinkId: 51, name: "Latte", image: "Drink_IcedLatte"),
                                    Drink(isIced: true, drinkId: 52, name: "Mocha", image: "Drink_IcedMocha"),
                                    Drink(isIced: true, drinkId: 53, name: "Cold brew", image: "Drink_Coldbrew"),
                                    Drink(isIced: false, drinkId: 6, name: "Espresso", image: "Drink_Espresso"),
                                    Drink(isIced: false, drinkId: 7, name: "Macchiato", image: "Drink_Macchiato")]

    private let moodList: [Mood] = [
                                    Mood(moodId: 0, name: "Happy", image: "😊"),
                                    Mood(moodId: 1, name: "Excited", image: "🥳"),
                                    Mood(moodId: 2, name: "Grateful", image: "🥰"),
                                    Mood(moodId: 3, name: "Relaxed", image: "😌"),
                                    Mood(moodId: 4, name: "Tired", image: "🫠"),
                                    Mood(moodId: 5, name: "Anxious", image: "🥺"),
                                    Mood(moodId: 6, name: "Angry",image: "🤬"),
                                    Mood(moodId: 7, name: "Sad", image: "😥"),
                                    Mood(moodId: 8, name: "Stressed", image: "🤯")]

    private let tagList: [Tag] = [
                                    Tag(tagId: 0, name: "Refreshing"),
                                    Tag(tagId: 1, name: "Morning"),
                                    Tag(tagId: 2, name: "Concentrating"),
                                    Tag(tagId: 3, name: "Socializing"),
                                    Tag(tagId: 4, name: "Working out"),
                                    Tag(tagId: 5, name: "Chilling"),
                                    Tag(tagId: 6, name: "Lunch"),
                                    Tag(tagId: 7, name: "Dinner")]
    
    private var commitCount: Int = 0
    private var userProfile: UserProfile?

    // tracker 관련 데이터
    private var guideline: Guideline?
    private var recordSummary: [Summary] = []
    
    
    private var todayCommits:[Commit] =  []
    private var weeklyCommits:[Commit] =  []
    
    private var monthlyCommits:[Commit] = []
    private var monthlySortedCommits: SortedDailyCommit?
    
    private var yearlyCommits:[Commit] = []
    private var allCommits:[Commit] = []

    func getDrinkListFromAPI() -> [Drink] {
        return drinkList
    }
    func getMoodListFromAPI() -> [Mood] {
        return moodList
    }
    func getTagListFromAPI() -> [Tag] {
        return tagList
    }
    
    // MARK: - 음료 등록
    typealias CommitCompletion = (Result<Date,NetworkError>) -> Void
    func uploadDrinkCommit(drinkId: Int, moodId: Int, tagIds: [Int], memo: String, completion: @escaping CommitCompletion ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(.uidError))
            return
        }
        
        let currentTime = Date()
        let commitData: [String: Any] = [
            Constant.FStore.uidField: uid,
            Constant.FStore.createdAtField: currentTime,
            Constant.FStore.drinkField : drinkId,
            Constant.FStore.moodField : moodId,
            Constant.FStore.tagListField : tagIds,
            Constant.FStore.memoField : memo,
        ]
        // 성공하면 시간 보낼 것
        commitManager.uploadCommit(data: commitData) { result in
            switch result {
            case .success:
                completion(.success(currentTime))
            case .failure:
                completion(.failure(.databaseError))
            }
        }
    }
    
    typealias deleteCompletion = (Result<Void,NetworkError>) -> Void
    func deleteCommit(id: String, completion: @escaping deleteCompletion ) {
        commitManager.deleteCommit(id: id) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let erorr):
                completion(.failure(erorr))
            }
        }
    }

    
    
    // MARK: - 총 commit 수
    func getCommitCountFromAPI(completion: @escaping(Result<Int,NetworkError>) -> Void) {
        authManager.getNumberOfCommits { result in
            switch result {
            case .success(let number):
                completion(.success(number))
                self.commitCount = number
            case .failure:
                completion(.failure(.databaseError))
            }
        }
    }
    func getCommitCount() -> Int {
        return commitCount
    }
    
    // MARK: - 유저 프로필 가져오기
    // 유저 프로필을 api에서 받으면, 그 데이터는 무조건 userDefault에 저장됨
    func getUserProfileFromAPI(completion: @escaping(Result<Void,NetworkError>) -> Void) {
        authManager.getUserProfile(completion: {[weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let data):
                weakSelf.saveProfiletoUserDefaults(userProfile: data)
                weakSelf.setProfileFromUserDefault()
                completion(.success(()))
            case .failure:
                completion(.failure(.dataError))
            }
        })
    }

    // api에서 받은 데이터를 userDefault에 저장한다.
    func saveProfiletoUserDefaults(userProfile: UserProfile) {
        Common.setUserDefaults(userProfile.name, forKey: .name)
        Common.setUserDefaults(userProfile.email, forKey: .email)
        Common.setUserDefaults(userProfile.cups, forKey: .cups)
        Common.setUserDefaults(userProfile.morningTime, forKey: .morningTime)
        Common.setUserDefaults(userProfile.nightTime, forKey: .nightTime)
        Common.setUserDefaults(userProfile.limitTime, forKey: .limitTime)
        Common.setUserDefaults(userProfile.reminder, forKey: .reminder)
    }
    
    func setProfileFromUserDefault() {
        guard let name = Common.getUserDefaultsObject(forKey: .name) as? String else { return }
        guard let email = Common.getUserDefaultsObject(forKey: .email) as? String else { return }
        guard let cups = Common.getUserDefaultsObject(forKey: .cups) as? Int else { return }
        guard let nightTime = Common.getUserDefaultsObject(forKey: .nightTime) as? String else { return }
        guard let morningTime = Common.getUserDefaultsObject(forKey: .morningTime) as? String else { return }
        guard let limitTime = Common.getUserDefaultsObject(forKey: .limitTime) as? String else { return }
        guard let reminder = Common.getUserDefaultsObject(forKey: .reminder) as? Bool else { return }
        
       // 어떤 값도 optional이 아니라면?
        let profile = UserProfile(name: name, cups: cups, email: email, morningTime: morningTime, nightTime: nightTime, limitTime: limitTime, reminder: reminder)
        self.userProfile = profile
    }
    
    func getUserData() -> UserProfile? {
        return userProfile
    }
    
    func updateUserPreference(data: UserPreference, completion: @escaping(Result<Void, NetworkError>) -> Void) {
        authManager.updateUserPreference(data: data) {[weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let data):
                weakSelf.saveProfiletoUserDefaults(userProfile: data)
                weakSelf.setProfileFromUserDefault()
                
                completion(.success(()))
            case .failure:
                completion(.failure(.dataError))
            }
        }
    }
    
    
    func updateUserProfile(name: String, completion: @escaping(Result<Void, NetworkError>) -> Void) {
        authManager.updateUserProfile(name: name) {[weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let data):
                weakSelf.saveProfiletoUserDefaults(userProfile: data)
                weakSelf.setProfileFromUserDefault()
                completion(.success(()))
            case .failure:
                completion(.failure(.dataError))
            }
        }
    }

    // MARK: - TRACKER - Today's memory
    // 오늘 날짜에 해당하는 commit을 api에서 패치
    // today에 해당하는 데이터 -> todayCommits에 저장
    // calculateGuideLineData -> 현재 유저의 설정 + today commit 숫자 합쳐서 guideline을 만든다.
    func fetchTodayCommits(completion: @escaping(Result<Void,NetworkError>) -> Void) {
        trackerManager.fetchTodayCommits { result in
            switch result {
            case .success(let data):
                self.todayCommits = data
                self.calculateGuidelineData()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    func getTodayCommits() -> [Commit] {
        return todayCommits
    }
    func getNumberOfTodayCommit() -> Int {
        return todayCommits.count
    }
    
    // MARK: - TRACKER - Caffeine Guideline
    func calculateGuidelineData() {
        if let profile = userProfile {
            let data = Guideline(limitTime: profile.limitTime, limitCup: profile.cups, currentCup: todayCommits.count)
            self.guideline = data
        }
    }
    
    func getGuidlineData() -> Guideline? {
        return self.guideline
    }

    // MARK: - TRACKER - Record
    func getTrackerRecord(completion: @escaping(Result<Void,NetworkError>)->Void) {
        Task {
            do {
                let all = try await trackerManager.fetchNumberOfAllCommits()
                let weekly = try await trackerManager.fetchNumberOfWeeklyCommits()
                let monthly = try await trackerManager.fetchNumberOfMonthlyCommits()
                let yearly = try await trackerManager.fetchNumberOfYearlyCommits()

                let data = [
                    Summary(title: "All your coffee memories", number: all),
                    Summary(title: "This Week", number: weekly),
                    Summary(title: "This Month", number: monthly),
                    Summary(title: "This Year", number: yearly),
                ]
                
                self.recordSummary = data
                completion(.success(()))
            } catch {
                completion(.failure(.dataError))
            }
        }
    }
    
    func getSummaryData() -> [Summary] {
        return self.recordSummary
    }

  // MARK: - 전체 commit 내용 가져오기 (Tracker - List에서)
    // allCommit에 저장
    func fetchAllCommits(completion: @escaping(Result<Void,NetworkError>) -> Void) {
        trackerManager.fetchAllCommits { result in
            switch result {
            case .success(let data):
                self.allCommits = data
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 현재의 AllCommit 변수에서 데이터를 가져와서 원하는 데이터 형식으로 바꿔서 리턴
    func getAllCommits() -> [CommitDetail] {
        var detailCommitList: [CommitDetail] = []
        allCommits.forEach { commit in
            if let commitDetail = getCommitDetailInfo(commit: commit) {
                detailCommitList.append(commitDetail)
            }
        }
        return detailCommitList
    }
    

    
    // MARK: - Record Calendar 뷰
    func getMonthlyDurationCommit(start: Date, finish: Date, completion: @escaping (Result<Void,NetworkError>) -> Void) {
        trackerManager.fetchDurationCommit(start: start, finish: finish) { result in
            switch result {
            case .success(let commits):
                // 날짜별로 정렬된 데이터
                let sortedData = self.sortCommitList(commits)
                self.monthlySortedCommits = sortedData
                completion(.success(()))
            case .failure:
                completion(.failure(.dataError))
            }
        }
    }
    
    // MARK: - 커밋 리스트가 있을 때 그걸 날짜별로 돌아가면서 정렬  [1: [commits...]]
    typealias SortedDailyCommit = [Int: [Commit]]
    func sortCommitList(_ commitList: [Commit]) -> SortedDailyCommit {
        var sortedData: [Int: [Commit]] = [:]
        for commit in commitList {
            let calendar = Calendar.current
            let date = calendar.startOfDay(for: commit.createdAt)
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            let day = components.day!
            if var commitsForDate = sortedData[day] {
                commitsForDate.append(commit)
                sortedData[day] = commitsForDate
            } else {
                sortedData[day] = [commit]
            }
        }
        return sortedData
    }
    
    
    typealias SortedDailyDetailedCommit = [Date: [CommitDetail]]
    func sortDetailedCommitwithCreatedAt(_ commitList: [CommitDetail]) -> SortedDailyDetailedCommit {
    
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


    // MARK: - 날짜별로 묶여있는 리스트를 카운팅. 몇일에 몇개의 커밋인지 계산
    func countDailyCommit(_ data: SortedDailyCommit) -> [Int: Int] {
        var countingData: [Int: Int] = [:]
        data.forEach { (key: Int, value: [Commit]) in
            countingData[key] = value.count
        }
        return countingData
    }
    
    func getMonthlySortedCommits() -> SortedDailyCommit? {
        return self.monthlySortedCommits
    }
    
    func getMonthlySortedCommitCounting() -> [Int: Int]? {
        guard let monthlyData = self.monthlySortedCommits else { return nil }
        return self.countDailyCommit(monthlyData)
    }
    
    // commit 있을 때 그 commit의 해당 데이터들을 묶어줘서 CommitDetail로 만들어주는
    func getCommitDetailInfo(commit: Commit) -> CommitDetail? {
        if !drinkList.isEmpty, !moodList.isEmpty, !tagList.isEmpty {
            let drink = drinkList.filter { $0.drinkId == commit.drinkId }[0]
            let mood = moodList.filter { $0.moodId == commit.moodId }[0]
            var tags: [Tag] = []
            commit.tagIds.forEach { tagId in
                let findedTag = tagList.filter { $0.tagId == tagId}
                if !findedTag.isEmpty {
                    tags.append(findedTag[0])
                }
            }
            let commitDatil = CommitDetail(id: commit.id, uid: commit.uid, drink: drink, mood: mood, tagList: tags, memo: commit.memo, createdAt: commit.createdAt)
            return commitDatil
        } else {
            return nil
        }
    }
    
    
    func getTopDrinkList(commitList: [Commit]) {
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
            let drink = drinkList.filter { $0.drinkId == key }[0]
            index = index + 1
            return DrinkRanking(ranking: index, drink: drink, number: value)
        }
        let _ = drinkData[0...2]
    }
    
    
}
