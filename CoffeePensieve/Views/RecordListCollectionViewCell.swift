//
//  RecordListCollectionViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/19.
//

import UIKit

class RecordListCollectionViewCell: UICollectionViewCell {
    
    var commit: CommitDetail? {
        didSet {
            guard let commit = commit else { return }
            timeLabel.text = Common.changeDateToString(date: commit.createdAt)
            drinkImage.image = UIImage(named: commit.drink.image)
            let tempMode = commit.drink.isIced ? "🧊ICED" : "🔥HOT"
            drinkLabel.text = "\(tempMode) \(commit.drink.name.uppercased())"
            moodLabel.text = commit.mood.image
            tagLabel.text = commit.tagList.reduce("", { $0 + " " + "#\($1.name)" })
            memoLabel.text = commit.memo           
        }
    }
    
    let drinkImage: UIImageView = {
        let view = UIImageView()
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let drinkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = .primaryColor500
        label.textAlignment = .left
        return label
    }()
    
    lazy var labelStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [drinkLabel, tagLabel])
        st.axis = .vertical
        st.alignment = .fill
        st.distribution = .fillEqually
        return st
    }()
    
    let moodLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .primaryColor500
        label.textAlignment = .center
        return label
    }()

    let memoLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 3
        label.textColor = .grayColor500
        label.textAlignment = .left
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .primaryColor25
        self.backgroundColor?.withAlphaComponent(0.6)
        makeUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        addSubview(timeLabel)
        addSubview(drinkImage)
        addSubview(moodLabel)
        addSubview(labelStack)
        addSubview(memoLabel)

        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])

        drinkImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drinkImage.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            drinkImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            drinkImage.widthAnchor.constraint(equalToConstant: 40),
            drinkImage.heightAnchor.constraint(equalToConstant: 56),
        ])

        moodLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moodLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            moodLabel.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -54),
            moodLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            moodLabel.heightAnchor.constraint(equalToConstant: 56)
        ])
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelStack.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 11),
            labelStack.leadingAnchor.constraint(equalTo: drinkImage.trailingAnchor, constant: 12),
            labelStack.trailingAnchor.constraint(equalTo: moodLabel.leadingAnchor, constant: -12),
            labelStack.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        memoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            memoLabel.topAnchor.constraint(equalTo: drinkImage.bottomAnchor, constant: 12),
            memoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            memoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
        
    }
    
}
