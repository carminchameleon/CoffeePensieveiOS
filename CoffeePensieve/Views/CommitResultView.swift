//
//  CommitResultView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/08.
//

import UIKit

class CommitResultView: UIView {

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Tues, January 12 at 12:25 PM"
        label.font = FontStyle.footnote
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var firstLine: UIView = {
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 1))
        lineView.backgroundColor = .black
        return lineView
    }()
    
    lazy var secondLine: UIView = {
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 1))
        lineView.backgroundColor = .black
        return lineView
    }()
    
    lazy var userInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Coffee Memory"
        label.font = FontStyle.headline
        label.textColor = .black
        label.textAlignment = .center
        label.addSubview(firstLine)
        label.addSubview(secondLine)
       
        return label
    }()
    
    lazy var coffeeMenuTitle: UILabel = {
        let label = UILabel()
        label.text = "Coffee"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    lazy var coffeeImage: UIImageView = {
         let view = UIImageView()
         view.image = UIImage(named: "Drink_Americano")
         view.frame = CGRect(x: 0, y: 0, width: 40, height: 56)
         view.contentMode = .scaleToFill
         view.layer.cornerRadius = 10 // 이미지 뷰 모서리를 둥글게 만듭니다.
         view.layer.shadowColor = UIColor.black.cgColor // 그림자 색상을 검은색으로 설정합니다.
         view.layer.shadowOpacity = 0.5 // 그림자 투명도를 0.5로 설정합니다.
         view.layer.shadowOffset = CGSize(width: 0, height: 3) // 그림자의 위치를 조정합니다.
         view.layer.shadowRadius = 1 // 그림자의 크기를 설정합니다.
         view.layer.zPosition = -1
        return view
    }()
    
    lazy var coffeeLabel : UILabel = {
        let label = UILabel()
        label.text = "🔥ICED / LATTE"
        label.font = FontStyle.callOut
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var drinkLabelStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [coffeeImage, coffeeLabel])
        st.spacing = 8
        st.axis = .horizontal
        st.alignment = .fill
        st.distribution = .fill
        return st
    }()
    
    lazy var drinkContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 17
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()

    
    lazy var moodMenuTitle: UILabel = {
        let label = UILabel()
        label.text = "Mood"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    lazy var moodImage : UILabel = {
        let label = UILabel()
        label.text = "🥳"
        label.font = FontStyle.largeTitle
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let moodLabel : UILabel = {
        let label = UILabel()
        label.text = "HAPPY"
        label.font = FontStyle.callOut
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var moodLabelStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [moodImage, moodLabel])
        st.spacing = 8
        st.axis = .horizontal
        st.alignment = .fill
        st.distribution = .fill
        return st
    }()
    
    lazy var moodContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 17
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    lazy var memoMenuTitle: UILabel = {
        let label = UILabel()
        label.text = "Memo"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
  
    let memoView: UILabel = {
        let label = UILabel()
        label.text = "I had sushi with my coworker Simon. We treid a new place and it was amazing...! I will go there next week again!"
        label.font = FontStyle.callOut
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var tagMenuTitle: UILabel = {
        let label = UILabel()
        label.text = "Tag"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var tags: UILabel = {
        let label = UILabel()
        label.text = "#Morning #Concentrate"
        label.font = FontStyle.callOut
        label.textColor = .primaryColor500
        label.textAlignment = .left
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        addSubview(dateLabel)
        addSubview(drinkContainer)
        addSubview(userInfoLabel)
        addSubview(coffeeMenuTitle)
        addSubview(coffeeImage)
        addSubview(drinkLabelStackView)
        addSubview(drinkContainer)
        addSubview(moodMenuTitle)
        addSubview(moodLabelStackView)
        addSubview(moodContainer)
        addSubview(memoMenuTitle)
        addSubview(memoView)
        addSubview(tagMenuTitle)
        addSubview(tags)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
        ])
        
        
        userInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userInfoLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            userInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            userInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            userInfoLabel.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        firstLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstLine.topAnchor.constraint(equalTo: userInfoLabel.topAnchor, constant: 1),
            firstLine.leadingAnchor.constraint(equalTo: userInfoLabel.leadingAnchor, constant: 0),
            firstLine.trailingAnchor.constraint(equalTo: userInfoLabel.trailingAnchor, constant: 0),
            firstLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        secondLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondLine.topAnchor.constraint(equalTo: userInfoLabel.bottomAnchor, constant: 1),
            secondLine.leadingAnchor.constraint(equalTo: userInfoLabel.leadingAnchor, constant: 0),
            secondLine.trailingAnchor.constraint(equalTo: userInfoLabel.trailingAnchor, constant: 0),
            secondLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        coffeeMenuTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coffeeMenuTitle.topAnchor.constraint(equalTo: userInfoLabel.bottomAnchor, constant: 24),
            coffeeMenuTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            coffeeMenuTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
        ])
        
        drinkContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drinkContainer.topAnchor.constraint(equalTo: coffeeMenuTitle.bottomAnchor, constant: 4),
            drinkContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            drinkContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            drinkContainer.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        drinkLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drinkLabelStackView.heightAnchor.constraint(equalToConstant: 56),
            drinkLabelStackView.widthAnchor.constraint(equalToConstant: 240),
            drinkLabelStackView.topAnchor.constraint(equalTo: drinkContainer.topAnchor, constant: 10),
        ])
        
        coffeeImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coffeeImage.widthAnchor.constraint(equalToConstant: 40),
            coffeeImage.heightAnchor.constraint(equalToConstant: 56),
        ])
        
        moodMenuTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moodMenuTitle.topAnchor.constraint(equalTo: drinkContainer.bottomAnchor, constant: 24),
            moodMenuTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            moodMenuTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
        ])
        
        
        moodLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moodLabelStackView.heightAnchor.constraint(equalToConstant: 56),
            moodLabelStackView.topAnchor.constraint(equalTo: moodContainer.topAnchor, constant: 10),
        ])
        
        
        moodContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moodContainer.topAnchor.constraint(equalTo: moodMenuTitle.bottomAnchor, constant: 4),
            moodContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            moodContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            moodContainer.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        memoMenuTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            memoMenuTitle.topAnchor.constraint(equalTo: moodContainer.bottomAnchor, constant: 24),
            memoMenuTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            memoMenuTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
        ])
        
        memoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            memoView.topAnchor.constraint(equalTo: memoMenuTitle.bottomAnchor, constant: 4),
            memoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            memoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
        ])
        
        tagMenuTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagMenuTitle.topAnchor.constraint(equalTo: memoView.bottomAnchor, constant: 24),
            tagMenuTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            tagMenuTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
        ])
        
        tags.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tags.topAnchor.constraint(equalTo: tagMenuTitle.bottomAnchor, constant: 2),
            tags.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            tags.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            tags.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
