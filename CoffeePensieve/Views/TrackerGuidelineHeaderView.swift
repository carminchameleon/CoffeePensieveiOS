//
//  TrackerGuidelineHeaderView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/06/02.
//

import UIKit

class TrackerGuidelineHeaderView: UITableViewHeaderFooterView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontStyle.title2
        label.textColor = .primaryColor500
        return label
    }()
    
    let button : UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Show More", for: .normal)
        button.setTitleColor(.primaryColor400, for: .normal)
        button.titleLabel?.font = FontStyle.callOut
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // 헤더 뷰 설정
        contentView.backgroundColor = .white
        
        // 타이틀 레이블 설정
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
        ])
        
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
       ])
    }

       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
