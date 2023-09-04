//
//  CommitMainView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/01.
//

import UIKit

class CommitMainView: UIView {

    let greetingLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.title2
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var cheeringLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .grayColor500
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = ""
        return label
    }()

    let suggestionLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.callOut
        label.text = "Would you like to add your memory?"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var imageView: UIImageView = {
        let imageName = "Memory-0"
        let onboardingImage = UIImage(named: imageName)
        let imageView = UIImageView(image: onboardingImage!)
        imageView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        imageView.contentMode =  .scaleToFill
        return imageView
    }()
    
    // MARK: - 다음 동작 버튼
    let addButton = CustomButton(isEnabled: true, title: "Add Today's Coffee")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {

        self.addSubview(greetingLabel)
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            greetingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            greetingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])

        self.addSubview(cheeringLabel)
        cheeringLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cheeringLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 24),
            cheeringLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            cheeringLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
        
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
        ])

        self.addSubview(suggestionLabel)
        suggestionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            suggestionLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -130),
            suggestionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            suggestionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])

        
        self.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -88),
            addButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 36),
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -36),
            addButton.heightAnchor.constraint(equalToConstant: ContentHeight.buttonHeight)
        ])
    }
}

