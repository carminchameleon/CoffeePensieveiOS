//
//  PreferenceHeaderView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/26.
//

import UIKit

class PreferenceHeaderView: UITableViewHeaderFooterView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontStyle.callOut
        label.textColor = .primaryColor500
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        // 헤더 뷰 설정
        contentView.backgroundColor = .white

        // 타이틀 레이블 설정
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        ])
        
    }
 
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

}
