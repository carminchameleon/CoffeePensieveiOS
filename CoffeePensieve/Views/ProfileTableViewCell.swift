//
//  ProfileTableViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/26.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    let iconView: UIImageView = {
        let image = Symbols.question
        let imageView = UIImageView(image: image)
        imageView.tintColor = .primaryColor500
        return imageView
    }()
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.callOut
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()

  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.addSubview(menuLabel)
        self.addSubview(iconView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            iconView.heightAnchor.constraint(equalToConstant: 25),
            iconView.widthAnchor.constraint(equalToConstant: 25),
        ])
        
        
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            menuLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            menuLabel.heightAnchor.constraint(equalToConstant: 30),
            menuLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)

        ])
    }
}
