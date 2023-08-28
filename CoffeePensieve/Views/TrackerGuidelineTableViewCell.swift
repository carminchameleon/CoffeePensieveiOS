//
//  TrackerGuidelineTableViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/14.
//

import UIKit

final class TrackerGuidelineTableViewCell: UITableViewCell {

    var guideline: Guideline? {
        didSet {
            guard let guideline = guideline else { return }
    
            let limitCups = guideline.limitCup
            let todayCups = guideline.currentCup
            let limitTime = guideline.limitTime
            
            let leftCups = limitCups - todayCups
            let isCupOver = leftCups < 0

            let dateFormatter = DateFormatter()
            let localTime = TimeZone.current
            dateFormatter.timeZone = localTime
            dateFormatter.locale = Locale(identifier: "En")

            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let today = Date()
            let calendar = Calendar.current
            let myDateCom = calendar.dateComponents([.year, .month, .day], from: today)
            let limitString =  "\(myDateCom.year!)-\(myDateCom.month!)-\(myDateCom.day!) \(limitTime)"
            let limitDate = dateFormatter.date(from: limitString)!
            
            dateFormatter.dateFormat = "h:mm a"
            let currentTime = dateFormatter.string(from: today)
            let limitedTime = dateFormatter.string(from: limitDate)

            let components = calendar.dateComponents([.hour, .minute], from: today, to: limitDate)
            let hours = components.hour ?? 0
            let minutes = components.minute ?? 0
            
            let isTimeOver = hours <= 0 && minutes <= 0

            currentCupNumber.text = "\(limitCups) Cups - \(todayCups) Cups"
            if isCupOver {
                leftCupNumber.text = "\(-leftCups) Cups Over"
                leftCupNumber.textColor = .redColor500
            } else {
                leftCupNumber.text = "\(leftCups) Cups Left"
                leftCupNumber.textColor = .primaryColor500
            }
        
            currentTimeNumber.text = "\(limitedTime) - \(currentTime)"
            if isTimeOver {
                leftTimeNumber.text = hours == 0 ?  "\(-minutes) Mins Over" : "\(-hours) Hours Over"
                leftTimeNumber.textColor = .redColor500
            } else {
                leftTimeNumber.text = hours == 0 ?  "\(minutes) Mins Left" : "\(hours) Hours Left"
                leftTimeNumber.textColor = .primaryColor500

            }
            
        }
    }
    
    let cupTitle: UILabel = {
        let label = UILabel()
        label.text = "Cup Limit"
        label.font = FontStyle.headline
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    
    let currentCupTitle: UILabel = {
        let label = UILabel()
        label.text = "Cup Limit - You had"
        label.font = FontStyle.footnote
        label.textColor = .grayColor300
        label.textAlignment = .left
        return label
    }()
    
    let currentCupNumber: UILabel = {
        let label = UILabel()
        label.text = "0 Cups - 0 Cups"
        label.font = FontStyle.headline
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let leftCupNumber: UILabel = {
        let label = UILabel()
        label.text = "0 Cups Left"
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.textColor = .primaryColor300
        label.textAlignment = .right
        return label
    }()
    
    lazy var cupStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [currentCupNumber, leftCupNumber])
        st.axis = .horizontal
        st.alignment = .fill
        st.distribution = .fill
        return st
    }()
    
    let timeTitle: UILabel = {
        let label = UILabel()
        label.text = "Time Limit"
        label.font = FontStyle.subhead
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    
    let currentTimeTitle: UILabel = {
        let label = UILabel()
        label.text = "Time Limit - Now"
        label.font = FontStyle.footnote
        label.textColor = .grayColor300
        label.textAlignment = .left
        return label
    }()
    
    let currentTimeNumber: UILabel = {
        let label = UILabel()
        label.text = "1:30 AM - 1:30 PM"
        label.font = FontStyle.headline
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let leftTimeNumber: UILabel = {
        let label = UILabel()
        label.text = "0 hours Left"
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.textColor = .primaryColor300
        label.textAlignment = .right
        return label
    }()

    lazy var timeStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [currentTimeNumber, leftTimeNumber])
        st.axis = .horizontal
        st.alignment = .fill
        st.distribution = .fill
        return st
    }()
    
    
    lazy var stackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [currentCupTitle, cupStackView, currentTimeTitle, timeStackView])
        st.axis = .vertical
        st.spacing = 0
        st.alignment = .fill
        st.distribution = .fillEqually
        return st
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.addSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
    
    func setConstraints() {
        self.backgroundColor =  #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
        ])
    }
}
