//
//  CalendarViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/16.
//

import UIKit

class CalendarViewController: UIViewController {

    let dataManager = DataManager.shared
    var monthlyCommitCounting: [Int: Int]?
    let monthlyRecordView = MonthlyRecordView()
    var isInitSetting = true
    
    var visibleDate: DateComponents? {
        didSet {
            if !isInitSetting, oldValue != visibleDate {
                updateCurrentCoffeeCommit()
            }
        }
    }
    
    override func loadView() {
        view = monthlyRecordView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation()
        getCurrentCalendar()
        monthlyRecordView.calendar.delegate = self
    }

    func setNavigation() {
        navigationItem.title = "Monthly"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .primaryColor500
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(listButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    // 오늘의 날짜 구하기 -> 구한걸로 패치해오기
    func getCurrentCalendar() {
        let today = Date()
        let calendar = Calendar.current
        
        let currentComponents = calendar.dateComponents([.year, .month], from: today)
        visibleDate = currentComponents
        
        // 이번 달의 시작 날짜 계산
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        
        dataManager.getMonthlyDurationCommit(start: startOfMonth, finish: today) {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                let data = strongSelf.dataManager.getMonthlySortedCommits()!
                
                let countingData = strongSelf.countDailyCommit(data)
                strongSelf.monthlyCommitCounting = countingData
                
                let updateList = strongSelf.makeFirstMonthDateComponentsList(countingData)
                DispatchQueue.main.async {
                    strongSelf.monthlyRecordView.calendar.reloadDecorations(forDateComponents: updateList, animated: true)
                }
                strongSelf.isInitSetting = true
            case .failure:
                let failAlert = UIAlertController(title: "Sorry", message: "Could not load your monthly coffee memories. Please try again later.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .default)
                failAlert.addAction(okayAction)
                strongSelf.present(failAlert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    // MARK: - 첫번째달의 업데이트할 데이트 리스트 만들기
    func makeFirstMonthDateComponentsList(_ commitDate: [Int:Int]) -> [DateComponents] {
        let date = Date()
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year, .month], from: date)
        let year = currentComponents.year!
        let month = currentComponents.month!
            
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let dayList = Array(commitDate.keys)
        var updateComponentsList: [DateComponents] = []
        
        dayList.forEach { day in
            var components = DateComponents()
            components.day = day
            components.month = month
            components.year = year
            updateComponentsList.append(components)
        }
        return updateComponentsList
    }
    
    
    
    // MARK: - 날짜별로 묶여있는 리스트를 카운팅. 몇일에 몇개의 커밋인지 계산
    func countDailyCommit(_ data: [Int: [Commit]]) -> [Int: Int] {
        var countingData: [Int: Int] = [:]
        data.forEach { (key: Int, value: [Commit]) in
            countingData[key] = value.count
        }
        return countingData
    }

    
    @objc func listButtonTapped() {
        let listVC = RecordListViewController()
        navigationController?.pushViewController(listVC, animated: true)
    }
}

extension CalendarViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
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
    

    func updateCurrentCoffeeCommit() {
        guard let visibleDate = visibleDate else { return }
        guard let firstDayOfMonth = visibleDate.date else { return }
        // 마지막 날짜 얻기 (해당 달 + 1 , 다음달의 0번째 날 : 그 전 달의 마지막 날)
        guard let month = visibleDate.month else { return }
        guard let year = visibleDate.year else { return }
      
        var components = DateComponents()
        components.year = year
        components.month = month + 1
        components.day = 0
        
        let calendar = Calendar.current
        let lastDayOfMonth = calendar.date(from: components)!
        
        dataManager.getMonthlyDurationCommit(start: firstDayOfMonth, finish: lastDayOfMonth) {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                
                let data = strongSelf.dataManager.getMonthlySortedCommits()!
                let countingData = strongSelf.countDailyCommit(data)
                strongSelf.monthlyCommitCounting = countingData
                let dateList = strongSelf.makeDateComponentsList(startDate: firstDayOfMonth, endDate: lastDayOfMonth)
                                                
                DispatchQueue.main.async {
                    strongSelf.monthlyRecordView.calendar.reloadDecorations(forDateComponents: dateList, animated: true)
                }
            case .failure:
                print("error 발생")
            }
        }
        
        
        
    }


//    // MARK: - after ios 16.2
//    func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents){
//        // 첫번째 날짜 얻기
//        let firstDayOfMonth = calendarView.visibleDateComponents.date!
//        // 마지막 날짜 얻기 (해당 달 + 1 , 다음달의 0번째 날 : 그 전 달의 마지막 날)
//        let month = calendarView.visibleDateComponents.month!
//        let year = calendarView.visibleDateComponents.year!
//
//        var components = DateComponents()
//        components.year = year
//        components.month = month + 1
//        components.day = 0
//
//        let calendar = Calendar.current
//        let lastDayOfMonth = calendar.date(from: components)!
//
//        dataManager.getMonthlyDurationCommit(start: firstDayOfMonth, finish: lastDayOfMonth) { result in
//            switch result {
//            case .success:
//
//                let data = self.dataManager.getMonthlySortedCommits()!
//                let countingData = self.countDailyCommit(data)
//                self.monthlyCommitCounting = countingData
//                let dateList = self.makeDateComponentsList(startDate: firstDayOfMonth, endDate: lastDayOfMonth)
//
//                DispatchQueue.main.async {
//                    calendarView.reloadDecorations(forDateComponents: dateList, animated: true)
//                }
//            case .failure:
//                print("error 발생")
//            }
//        }
//    }

    func makeDateComponentsList(startDate: Date, endDate:Date) -> [DateComponents] {
        let calendar = Calendar.current

        let startDateComponents = calendar.dateComponents([.year, .month, .day], from: startDate)
        let endDateComponents = calendar.dateComponents([.year, .month, .day], from: endDate)

        var currentDate = calendar.date(from: startDateComponents)!

        var dateComponentsArray: [DateComponents] = []
        while currentDate <= calendar.date(from: endDateComponents)! {
            let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
            dateComponentsArray.append(dateComponents)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return dateComponentsArray

    }
    
    
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
    
}

