//
//  AuthStartPointView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/14.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

class AuthStartPointView: UIView {
    
    private let buttonHeight: CGFloat = 48
    
    // MARK: - 앱 이름
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Coffee\nPensieve"
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - 회원가입 안내 타이틀
    private lazy var signUpLabel: UILabel = {
        var label = UILabel()
        label.text = "Create an account to \n make your coffee tracker"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - 회원가입 안내 타이틀
    lazy var emailButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.title = "Contiune with Email "
        filled.buttonSize = .medium
        filled.image = UIImage(systemName: "envelope")
        filled.imagePlacement = .leading
        filled.imagePadding = 3
        filled.baseBackgroundColor = .primaryColor500
        
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        return button
    }()
    
    
    // MARK: - 회원가입 안내 타이틀
    lazy var googleButton: UIButton = {
        var button = UIButton()
        let image = UIImage(named: "GoogleIcon")?.resized(toWidth: 20)
        button.setImage(image, for: .normal)
        button.setTitle("  Continue with Google", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .primaryColor500
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        return button
    }()
    
    
    // MARK: - 회원가입 안내 타이틀
    lazy var appleButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.title = "Contiune with Apple "
        filled.buttonSize = .medium
        filled.image = UIImage(systemName: "apple.logo")
        filled.imagePlacement = .leading
        filled.imagePadding = 3
        filled.baseBackgroundColor = .primaryColor500
        
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        return button
    }()
        
    lazy var stackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [emailButton, googleButton, appleButton])
        st.spacing = 12
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        return st
    }()
    
    lazy var infoLabel: UILabel = {
        let text = "By tapping Continue, You agree to our Terms and"
        let termRange = NSRange(location: 38, length: 5)
        
        // NSAttributedString 생성
        let attributedString = NSMutableAttributedString(string: text)
        let termURL = URL(string: Constant.Web.terms)!

        attributedString.addAttribute(.link, value: termURL, range: termRange)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .center
        label.attributedText = attributedString
        return label
    }()
    
    
    lazy var policyLabel: UILabel = {
        let text = "acknowlege that you have read our Privacy Policy."
        let privacyRange =  NSRange(location: 34, length: 14)
        
        // NSAttributedString 생성
        let attributedString = NSMutableAttributedString(string: text)
        let policyURL = URL(string: Constant.Web.policy)!
        
        attributedString.addAttribute(.link, value: policyURL, range: privacyRange)
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .center
        label.attributedText = attributedString
        return label
    }()
    
    
    // MARK: - 로그인 버튼
    lazy var loginButton: UIButton = {
        let text = "Have an account? Log in"
        let range = NSRange(location: 17, length: 6)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range:range)
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        backgroundColor = .white
        
        addSubview(appNameLabel)
        addSubview(signUpLabel)
        addSubview(stackView)
        addSubview(infoLabel)
        addSubview(policyLabel)

        addSubview(loginButton)
        
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        policyLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            appNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            signUpLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            signUpLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 36),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.heightAnchor.constraint(equalToConstant: buttonHeight * 3 + 24)
        ])
    
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 36),
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        NSLayoutConstraint.activate([
            policyLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 0),
            policyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
