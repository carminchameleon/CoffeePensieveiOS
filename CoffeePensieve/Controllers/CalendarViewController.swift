//
//  CalendarViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/16.
//

import UIKit


final class CalendarViewController: UIViewController {
    
    typealias DurationTuple = (startDate: Date, endDate: Date)
    
    let monthlyRecordView = MonthlyRecordView()
    let trackerManger = TrackerNetworkManager.shared

    var isInitSetting = true
    var monthlyCommitCounting: [Int: Int]?
    var visibleDate: DateComponents? {
        didSet {
            if !isInitSetting, oldValue != visibleDate, visibleDate != nil  {
                setNewCalendarData()
            }
        }
    }

    override func loadView() {
        view = monthlyRecordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setInitialCalenderData()
        monthlyRecordView.calendar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 다른 화면에서 넘어왔을 경우에도, 데이터가 바뀌었을 가능성이 있으므로 새로운 데이터로 업데이트
        if !isInitSetting {
            setNewCalendarData()
        }
    }
    
    func setNavigation() {
        navigationItem.title = "Monthly"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .primaryColor500
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(listButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func listButtonTapped() {
        let listVC = RecordListViewController()
        navigationController?.pushViewController(listVC, animated: true)
    }
    
    // MARK: - 현재 날짜 기준의 캘린더 데이터
    func setInitialCalenderData() -> Void {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let duration = self.getCurrentMonthDuration()
                let data = try await self.fetchCommitListWithDuration(duration: duration)
                self.monthlyCommitCounting = data
                let dateList = self.makeFirstMonthDateComponentsList(data)
                DispatchQueue.main.async {
                    self.monthlyRecordView.calendar.reloadDecorations(forDateComponents: dateList, animated: true)
                }
            } catch {
                AlertManager.showTextAlert(on: self, title: "Sorry", message: "Could not load your monthly data. Please try again later.")
            }
        }
    }
    
    // MARK: - 새롭게 보여지는 캘린더 기준의 캘린더 데이터
    func setNewCalendarData() -> Void {
        Task {[weak self] in
            guard let self = self else { return }
            do {
                let duration = getCalendarDuration()
                let data = try await self.fetchCommitListWithDuration(duration: duration)
                self.monthlyCommitCounting = data
                let dateList = self.makeDateComponentsList(duration: duration)
                DispatchQueue.main.async {
                    self.monthlyRecordView.calendar.reloadDecorations(forDateComponents: dateList, animated: true)
                }
            } catch {
                AlertManager.showTextAlert(on: self, title: "Sorry", message: "Could not load your monthly data. Please try again later.")
            }

        }
    }
    
    // 그 달의 시작, 오늘 날짜 구하기
    func getCurrentMonthDuration() -> DurationTuple {
        let today = Date()
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        return (startOfMonth, today)
    }
    
    // 보여질 캘린더의 시작, 끝 날짜 구하기
    func getCalendarDuration() -> DurationTuple {
        let visibleMonth = visibleDate!
        let firstDayOfMonth = visibleMonth.date!
        // 마지막 날짜 얻기 (해당 달 + 1 , 다음달의 0번째 날 : 그 전 달의 마지막 날)
        let month = visibleMonth.month!
        let year = visibleMonth.year!
        
        var components = DateComponents()
        components.year = year
        components.month = month + 1
        components.day = 1
        
        let calendar = Calendar.current
        let lastDayOfMonth = calendar.date(from: components)!
        return (firstDayOfMonth, lastDayOfMonth)
    }
    
    // MARK: - 기간에 해당하는 커밋 데이터 패치
    // 시작 날짜와 종료 날짜로 DB에서 해당 commit 리스트 받고, view에 필요한 데이터 형식으로 변환
    func fetchCommitListWithDuration(duration: DurationTuple) async throws -> [Int : Int] {
        let commitList = try await trackerManger.fetchDurationCommitList(start: duration.startDate, finish: duration.endDate) // CommitList
        let sortedData = self.sortCommitsByDate(commitList) // 날짜: Commits
        let convertedData = self.convertDrinkListToCount(sortedData) // 날짜: Commit Count
        return convertedData
    }
    
    /**
     - 첫번째달의 업데이트할 데이트 리스트 만들기
     - Parameters : commitDate [날짜, 커피 숫자]
     - Returns:DateComponents 리스트, 현재 달 + 날짜 리스트를 결합해서 date Components로 바꾼 형식
     - Example
        input : [28: 3, 4: 1, 23: 2, 24: 15, 25: 16, 13: 1, 17: 1, 22: 4, 11: 3, 16: 3, 10: 1]
        output: [year: 2023 month: 8 day: 28 isLeapMonth: false , year: 2023 month: 8 day: 4 isLeapMonth: false , year: 2023 month: 8 day: 23 isLeapMonth: false .... ]
     **/
    func makeFirstMonthDateComponentsList(_ commitDate: [Int:Int]) -> [DateComponents] {
        let date = Date()
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year, .month], from: date)
        let year = currentComponents.year!
        let month = currentComponents.month!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let dayList = Array(commitDate.keys)
        
        let updateComponentsList: [DateComponents] = dayList.map { day in
            var components = DateComponents()
            components.day = day
            components.month = month
            components.year = year
            return components
        }
        return updateComponentsList
    }
    
    /**
     - Description: 특정 기간에 해당하는 모든 날짜 DateComponents 리스트를 만든다.
     - Parameters: duration (startDate, endDate)
     - Returns: 기간에 해당하는 모든 날짜 리스트[dateComponents]
     - Example
        input - 2023-07-31 14:00:00 +0000 2023-08-30 14:00:00 +0000
        output -  [year: 2023 month: 8 day: 1 isLeapMonth: false , year: 2023 month: 8 day: 2 isLeapMonth: false , year: 2023 month: 8 day: 3 isLeapMonth: false .... ]
     **/
    func makeDateComponentsList(duration: DurationTuple) -> [DateComponents] {
        
        let calendar = Calendar.current
        let startDateComponents = calendar.dateComponents([.year, .month, .day], from: duration.startDate)
        let endDateComponents = calendar.dateComponents([.year, .month, .day], from: duration.endDate)
        
        var currentDate = calendar.date(from: startDateComponents)!

        var dateComponentsArray: [DateComponents] = []
        while currentDate <= calendar.date(from: endDateComponents)! {
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
            dateComponentsArray.append(dateComponents)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dateComponentsArray
    }
    

}

extension CalendarViewController: UICalendarViewDelegate {
    // MARK: - 1. 현재 보여지는 DateComponents를 visible Date로 업데이트 2. 해당 날짜의 커피 데이터 보여줌
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        // 현재 보여지는 Cell을 데코레이션 할 것
        visibleDate = calendarView.visibleDateComponents
        isInitSetting = false
        guard let day = dateComponents.day else {
            return nil
        }
        
        guard let monthlyData = self.monthlyCommitCounting else { return nil }
        if let counting = monthlyData[day] {
            let font = UIFont.systemFont(ofSize: 17)
            let configuration = UIImage.SymbolConfiguration(font: font)
            let color = getCellColor(counting)
            let image = UIImage(systemName: "cup.and.saucer.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal).withTintColor(color)
            return .image(image)
        }
        return nil
    }
}

extension CalendarViewController {
    
    func getCellColor(_ counting: Int) -> UIColor {
        switch counting {
        case 1:
            return .primaryColor100
        case 2:
            return .primaryColor200
        case 3:
            return .primaryColor300
        case 4:
            return .primaryColor400
        case 5:
            return .primaryColor500
        case 6:
            return .primaryColor600
        default:
            return .primaryColor700
        }
    }
    
    // MARK: - 커밋 리스트가 있을 때 그걸 날짜별로 돌아가면서 정렬  [1: [commits...]]
    /**
     - Description: 기본 커밋 리스트를 날짜별로 [day: [commits]] 정렬
     - Parameters:
       - commitList: 날짜 리스트
     - Returns: 날짜별로 정렬된 리스트
     **/
    typealias SortedCommitListByDate = [Int: [Commit]]
    func sortCommitsByDate(_ commitList: [Commit]) -> SortedCommitListByDate {
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
    
    
    // MARK: - 날짜별로 묶여있는 리스트를 카운팅. 몇일에 몇개의 커밋인지 계산
    /**
     - Description: 날짜별로 묶여있는 리스트를 카운팅. 몇일에 몇개의 커밋인지 계산
     - Parameters: data (날짜: [해당 날짜의 커밋 리스트] // [13: [Coffee_Pensieve.Commit(id: "mw3J9fLRaXFeOraRBppI", uid: "pZBWmbHaC9P8e3HJKhorARCcmxx1", drinkId: 1, moodId: 4, tagIds: [1], memo: "" ...]
     - Returns:[날짜: 해당 날짜의 커밋 숫자] //  [2: 1, 13: 1, 30: 2, 1: 3, 4: 1]
     **/
    func convertDrinkListToCount(_ data: SortedCommitListByDate) -> [Int: Int] {
        var countingData: [Int: Int] = [:]
        data.forEach { (key: Int, value: [Commit]) in
            countingData[key] = value.count
        }
        return countingData
    }

}
