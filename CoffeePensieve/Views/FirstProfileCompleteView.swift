//
//  FirstProfileCompleteView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/17.
//

import UIKit

class FirstProfileCompleteView: UIView {

    private let buttonHeight: CGFloat = 56
    
    private lazy var mainTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "Congratulations! \n your own coffee pensieve \n has been created."
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 3
        label.textAlignment = .center

        return label
    }()
    
    var imageView: UIImageView = {
        let imageName = "Memory-1"
        let onboardingImage = UIImage(named: imageName)
        let imageView = UIImageView(image: onboardingImage!)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.contentMode =  .scaleToFill
    
        return imageView
    }()
    
    private lazy var subTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "From now on, \n You can keep your memory in there"
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center

        return label
    }()
    
    // MARK: - 다음 버튼
    lazy var nextButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("START", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.primaryColor500, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
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
        
        addSubview(mainTitleLabel)
        addSubview(imageView)
        addSubview(subTitleLabel)
        addSubview(nextButton)
        
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            mainTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            mainTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            mainTitleLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 400),
            imageView.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 12),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80),
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            nextButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        
    }


}
