//
//  OnboardingView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/14.
//

import UIKit

class OnboardingView: UIView {
    
    let imageView: UIImageView = {
        let imageName = "Cloud 1"
        let onboardingImage = UIImage(named: imageName)
        let imageView = UIImageView(image: onboardingImage!)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let mainTitle : UILabel = {
        let label = UILabel()
        label.text = "Create an account to \n make your coffee tracker"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    
    let subTitle : UILabel = {
        let label = UILabel()
        label.text = "how many cups of coffee do you drink a day? \n What made you need a coffee? \n Keep your coffee moment."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [mainTitle, subTitle])
        st.spacing = 8
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        return st
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func makeUI() {
        backgroundColor = .primaryColor25

        addSubview(imageView)
        addSubview(stackView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 200),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)]
        )
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 44),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    
}
