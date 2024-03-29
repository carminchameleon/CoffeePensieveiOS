//
//  DocketView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/17.
//

import UIKit

class DocketView: UIView {
    
    let createdAtLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = FontStyle.subhead
        label.textAlignment = .center
        label.textColor = .primaryColor25
        return label
    }()
    
    
    let coffeeLabel: UILabel = {
        let label = UILabel()
        label.text = "Coffee"
        label.font = FontStyle.subhead
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let coffeeImage: UIImageView = {
         let view = UIImageView()
         view.image = UIImage(named: "Drink_Americano")
         view.frame = CGRect(x: 0, y: 0, width: 100, height: 140)
         view.contentMode = .scaleToFill
         view.layer.cornerRadius = 10 // 이미지 뷰 모서리를 둥글게 만듭니다.
         view.layer.shadowColor = UIColor.black.cgColor // 그림자 색상을 검은색으로 설정합니다.
         view.layer.shadowOpacity = 0.5 // 그림자 투명도를 0.5로 설정합니다.
         view.layer.shadowOffset = CGSize(width: 0, height: 3) // 그림자의 위치를 조정합니다.
         view.layer.shadowRadius = 1 // 그림자의 크기를 설정합니다.
        return view
    }()
    
    let drinkLabel : UILabel = {
        let label = UILabel()
        label.text = "🔥HOT / AMERICANO"
        label.font = FontStyle.callOut
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var drinkStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [coffeeImage, drinkLabel])
        st.spacing = 8
        st.axis = .vertical
        st.alignment = .center
        st.distribution = .fill
        return st
    }()
    
    
    let moodTitle: UILabel = {
        let label = UILabel()
        label.text = "Feeling"
        label.font = FontStyle.subhead
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let moodImage : UILabel = {
        let label = UILabel()
        label.text = "🥳"
        label.font = UIFont.systemFont(ofSize: 58)
        label.textAlignment = .center
        return label
    }()
    
    let moodLabel : UILabel = {
        let label = UILabel()
        label.font = FontStyle.callOut
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var moodStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [moodImage, moodLabel])
        st.spacing = 8
        st.axis = .vertical
        st.alignment = .center
        st.distribution = .fill
        return st
    }()
    
    let detailTitle: UILabel = {
        let label = UILabel()
        label.text = "Memo"
        label.font = FontStyle.subhead
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    
    let memoView: UITextView = {
        let textView = UITextView()
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.textAlignment = .left
        textView.font = UIFont.italicSystemFont(ofSize: 17)
        textView.isSelectable = true
        textView.isEditable = false
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        textView.layer.cornerRadius = 12
        textView.backgroundColor = UIColor.init(red: 0/255, green: 17/255, blue: 74/255, alpha: 0.1)
        textView.textColor = .white
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.spellCheckingType = UITextSpellCheckingType.no
        textView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    
    let detailView: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()

    let tagTitle: UILabel = {
        let label = UILabel()
        label.text = "Tag"
        label.font = FontStyle.subhead
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let tags: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.textColor = .white
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
        addSubview(createdAtLabel)
        addSubview(coffeeLabel)
        addSubview(drinkStack)
        addSubview(moodTitle)
        addSubview(moodStack)
        addSubview(tagTitle)
        addSubview(tags)
        addSubview(detailTitle)

        createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createdAtLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12),
            createdAtLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            createdAtLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])
        

        coffeeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coffeeLabel.topAnchor.constraint(equalTo: createdAtLabel.bottomAnchor, constant: 20),
            coffeeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            coffeeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])
        
        drinkStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drinkStack.topAnchor.constraint(equalTo: coffeeLabel.bottomAnchor, constant: 12),
            drinkStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            drinkStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            drinkStack.heightAnchor.constraint(equalToConstant: 108)
        ])
        
        coffeeImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coffeeImage.widthAnchor.constraint(equalToConstant: 49),
            coffeeImage.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        moodTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moodTitle.topAnchor.constraint(equalTo: drinkStack.bottomAnchor, constant: 20),
            moodTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            moodTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])
        
        moodStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moodStack.topAnchor.constraint(equalTo: moodTitle.bottomAnchor, constant: 12),
            moodStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            moodStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            moodStack.heightAnchor.constraint(equalToConstant: 98)
        ])
     
        
        tagTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagTitle.topAnchor.constraint(equalTo: moodStack.bottomAnchor, constant: 12),
            tagTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            tagTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])
        
        tags.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tags.topAnchor.constraint(equalTo: tagTitle.bottomAnchor, constant: 12),
            tags.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            tags.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])
        
        detailTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailTitle.topAnchor.constraint(equalTo: tags.bottomAnchor, constant: 20),
            detailTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            detailTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])

    }
    
}

