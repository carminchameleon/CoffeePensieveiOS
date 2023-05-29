//
//  PreferenceCupTableViewCell.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/27.
//

import UIKit

class PreferenceCupTableViewCell: UITableViewCell {

    var model: PreferenceCell? = nil {
        didSet {
            guard let model = model else { return }
            iconView.image = UIImage(systemName: model.icon)
            menuLabel.text = model.title
            cupLabel.text = model.data
        }
    }
    
    let iconView: UIImageView = {
        let image = UIImage(systemName: "questionmark.circle")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .primaryColor200
        return imageView
    }()
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.callOut
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    

    let cupLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.callOut
        label.text = "3 CUPS"
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.addSubview(menuLabel)
        self.addSubview(iconView)
        self.addSubview(cupLabel)

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

        cupLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cupLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            cupLabel.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -200),
            cupLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            cupLabel.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])
    }

}
