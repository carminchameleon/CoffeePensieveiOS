//
//  RecordEmptyView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/06/02.
//

import UIKit

class RecordEmptyView: UIView {
    
    var imageView: UIImageView = {
        let imageName = "Memory-0"
        let onboardingImage = UIImage(named: imageName)
        let imageView = UIImageView(image: onboardingImage!)
        imageView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        imageView.contentMode =  .scaleToFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Oh! \n You didn't put any memory yet. \n Would you like to add first memory?"
        label.font = FontStyle.callOut
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .primaryColor400
        return label
    }()
    
    
    let addButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("YES! Let's do it", for: .normal)
        button.titleLabel?.font = FontStyle.body
        button.setTitleColor(UIColor.primaryColor25, for: .normal)
        button.backgroundColor = .primaryColor500
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.isEnabled = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func makeUI() {
        backgroundColor = .white
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(addButton)
        
       NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -80),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
       ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(equalToConstant: 100),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

        ])
        
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            addButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
    }

}
