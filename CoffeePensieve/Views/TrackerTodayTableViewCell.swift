//
//  TrackerTodayTableViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/13.
//

import UIKit

final class TrackerTodayTableViewCell: UITableViewCell {
    
    let dataManager = DataManager.shared
    
    var commit: Commit? {
        didSet {
            guard let commit = commit else { return }
            
            // drink
            let drinkList = dataManager.getDrinkListFromAPI()
            let selectedDrink = drinkList.filter { $0.drinkId == commit.drinkId }
            if !selectedDrink.isEmpty {
                let drink = selectedDrink[0]
                let selectedDrinkImage =  UIImage(named: drink.image)
                drinkImage.image = selectedDrinkImage
                let tempMode = drink.isIced ? "🧊ICED" : "🔥HOT"
                let drinkText = "\(tempMode) / \(drink.name.uppercased())"
                drinkLabel.text = drinkText
                drinkImage.alpha = 1
            }
        
            // tag
            var tagText = ""
            let allTagList = dataManager.getTagListFromAPI()
            commit.tagIds.forEach { tagId in
                let findedTag = allTagList.filter { $0.tagId == tagId}
                if !findedTag.isEmpty {
                    let tag = findedTag[0].name
                    tagText.append("#\(tag) ")
                }
            }
            tagLabel.text = tagText
                
            // mood
            let moodList = dataManager.getMoodListFromAPI()
            let mood = moodList.filter { $0.moodId == commit.moodId }[0]
            let moodImage = mood.image
            moodLabel.text = moodImage
                    
            let dateFormatter = DateFormatter()
            let localTime = TimeZone.current
            dateFormatter.timeZone = localTime
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.locale = Locale(identifier: "En")
            let createdAt = dateFormatter.string(from: commit.createdAt)
            timeLabel.text = createdAt

        }
    }

    let drinkImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Drink_Americano")
        view.alpha = 0.2
        view.frame = CGRect(x: 0, y: 0, width: 36, height: 52)
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 1
        return view
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let drinkLabel: UILabel = {
        let label = UILabel()
        label.text = "You haven't had coffee yet."
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = .primaryColor500
        label.textAlignment = .left

        return label
    }()
    
    lazy var labelStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [timeLabel, drinkLabel, tagLabel])
        st.axis = .vertical
        st.alignment = .fill
        st.distribution = .fillEqually

        return st
    }()
    
    let moodLabel: UILabel = {
        let label = UILabel()
        label.text = "🤔"
        label.font = FontStyle.largeTitle
        label.textColor = .primaryColor500
        label.textAlignment = .center
        return label
    }()

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.addSubview(drinkImage)
        self.addSubview(labelStack)
        self.addSubview(moodLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
    
    func setConstraints() {
        
        self.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
        
        drinkImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drinkImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            drinkImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            drinkImage.widthAnchor.constraint(equalToConstant: 40),
            drinkImage.heightAnchor.constraint(equalToConstant: 56),
        ])
        
        moodLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moodLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            moodLabel.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            moodLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            moodLabel.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            labelStack.leadingAnchor.constraint(equalTo: drinkImage.trailingAnchor, constant: 12),
            labelStack.trailingAnchor.constraint(equalTo: moodLabel.leadingAnchor, constant: -12),
            labelStack.heightAnchor.constraint(equalToConstant: 56)
        ])
        
    }
}
