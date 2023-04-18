//
//  PasswordResetSuccessView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/15.
//

import UIKit

class ResetPasswordSuccessView: UIView {
    
    
    private let buttonHeight: CGFloat = 56
    
    // MARK: - 성공
    private lazy var mainLabel: UILabel = {
        var label = UILabel()
        label.text = "You got it!"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - 성공 멘트
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Your password has been reset succesfully! \n Now login with your new password"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - 다음 동작 버튼
    let loginButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
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
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainLabel)
        addSubview(infoLabel)
        addSubview(loginButton)
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 18),
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 18),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            loginButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
}
