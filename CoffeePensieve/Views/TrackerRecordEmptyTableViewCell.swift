//
//  TrackerRecordEmptyTableViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/06/05.
//

import UIKit

class TrackerRecordEmptyTableViewCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "You didn't put any memory yet \n We will organize your coffee history here"
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .primaryColor500
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .primaryColor25
        self.addSubview(titleLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
        ])
    }
}
