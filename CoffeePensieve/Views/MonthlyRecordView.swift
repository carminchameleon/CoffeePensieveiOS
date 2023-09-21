//
//  MonthlyRecordView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/06/09.
//

import UIKit

final class MonthlyRecordView: UIView {

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
       return calendarView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI(){
        addSubview(calendar)
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            calendar.trailingAnchor .constraint(equalTo: trailingAnchor, constant: 0),
            calendar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            calendar.heightAnchor.constraint(equalToConstant: 500)
         ])
    }
}
