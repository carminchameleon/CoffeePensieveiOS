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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        getCurrentCalendar()
    }
    
    func getCurrentCalendar() {
        let today = Date()
        let calendar = Calendar.current
        // 이번 달의 시작 날짜 계산
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        dataManager.getMonthlyDurationCommit(start: startOfMonth, finish: today) {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                let data = strongSelf.dataManager.getMonthlySortedCommits()!
                let countingData = strongSelf.countDailyCommit(data)
                strongSelf.monthlyCommitCounting = countingData
                DispatchQueue.main.async {
                    strongSelf.createCalendar()
                }
            case .failure:
                strongSelf.createCalendar()
                let failAlert = UIAlertController(title: "Sorry", message: "Could not load your monthly coffee memories. Please try again later.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .default)
                failAlert.addAction(okayAction)
                strongSelf.present(failAlert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - 날짜별로 묶여있는 리스트를 카운팅. 몇일에 몇개의 커밋인지 계산
    func countDailyCommit(_ data: [Int: [Commit]]) -> [Int: Int] {
        var countingData: [Int: Int] = [:]
        data.forEach { (key: Int, value: [Commit]) in
            countingData[key] = value.count
        }
        return countingData
    }

    func setNavigation() {
        navigationItem.title = "Monthly"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .primaryColor500
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(listButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func createCalendar() {
//        self.view.backgroundColor = .white
        
        let calendarView = UICalendarView()
        calendarView.fontDesign = .rounded
        calendarView.delegate = self
        calendarView.tintColor = .primaryColor500
        
//        calendarView.backgroundColor = .primaryColor25
        calendarView.clipsToBounds = true
        calendarView.layer.cornerRadius = 12
        calendarView.calendar = .current
        calendarView.locale = Locale(identifier: "En")
        
        let startDateString = "01/01/2023"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let startDate = dateFormatter.date(from: startDateString)!
        calendarView.availableDateRange = DateInterval(start: startDate, end: .now)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
       
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
        ])
    }
    
    @objc func listButtonTapped() {
        let listVC = RecordListViewController()
        navigationController?.pushViewController(listVC, animated: true)
    }
}

extension CalendarViewController: UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
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
    

    
    func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents){
        
        // 첫번째 날짜 얻기
        let firstDayOfMonth = calendarView.visibleDateComponents.date!
        // 마지막 날짜 얻기 (해당 달 + 1 , 다음달의 0번째 날 : 그 전 달의 마지막 날)
        let month = calendarView.visibleDateComponents.month!
        let year = calendarView.visibleDateComponents.year!
        
        var components = DateComponents()
        components.year = year
        components.month = month + 1
        components.day = 0
        
        let calendar = Calendar.current
        let lastDayOfMonth = calendar.date(from: components)!
        
        dataManager.getMonthlyDurationCommit(start: firstDayOfMonth, finish: lastDayOfMonth) { result in
            switch result {
            case .success:
                let data = self.dataManager.getMonthlySortedCommits()!
                let countingData = self.countDailyCommit(data)
                self.monthlyCommitCounting = countingData
            case .failure:
                print("error 발생")
            }
        }
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

