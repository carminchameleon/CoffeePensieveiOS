//
//  MonthlyRecordView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/06/09.
//

import UIKit

class MonthlyRecordView: UIView {

    let calendar: UICalendarView = {
        let calendarView = UICalendarView()
        calendarView.fontDesign = .rounded
        calendarView.tintColor = .primaryColor500
        
        calendarView.clipsToBounds = true
        calendarView.layer.cornerRadius = 12
        calendarView.calendar = .current
        calendarView.locale = Locale(identifier: "En")
        
        let startDateString = "01/03/2023"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let startDate = dateFormatter.date(from: startDateString)!
        calendarView.availableDateRange = DateInterval(start: startDate, end: .now)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
       return calendarView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(calendar)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI(){
        
     addSubview(calendar)
         NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            calendar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            calendar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
         ])
    }
    
    
}
