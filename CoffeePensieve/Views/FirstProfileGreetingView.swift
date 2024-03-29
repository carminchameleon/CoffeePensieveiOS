//
//  FirstProfileGreetingView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/16.
//

import UIKit

final class FirstProfileGreetingView: UIView {
        
    private let mainTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Hi! Nice to meet you.\n Welcome to Coffee Pensieve!"
        label.fadeTransition(0.4)
        label.font = FontStyle.title3
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let imageView: UIImageView = {
        let imageName = "Memory-0"
        let onboardingImage = UIImage(named: imageName)
        let imageView = UIImageView(image: onboardingImage!)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.contentMode =  .scaleToFill
        return imageView
    }()
    
    private let subTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "To make your own pensieve, \n I'd love to get to know you a little better!"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - 다음 버튼
    let nextButton: UIButton = {
        let button = UIButton(type:.custom)
        let iconImage = UIImage(systemName: "chevron.forward.circle")
        let resizedImage = iconImage?.resized(toWidth: 52) // 아이콘 사이즈 설정
        button.setImage(resizedImage, for: .normal)
        button.setImageTintColor(.primaryColor400) // 아이콘 색 설정
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
    
        addSubview(mainTitleLabel)
        addSubview(imageView)
        addSubview(subTitleLabel)
        addSubview(nextButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
        ])
    
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -120),
            mainTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            mainTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            mainTitleLabel.heightAnchor.constraint(equalToConstant: 120)
        ])

        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
    }

}
