//
//  StartPointViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/09.
//

import UIKit

class StartPointViewController: UIViewController {

    private let buttonHeight: CGFloat = 48

    // MARK: - 앱 이름
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Coffee \n Pensieve"
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
        button.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)

        return button
    }()
    
    // MARK: - 회원가입 안내 타이틀
    lazy var googleButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.title = "Contiune with Google"
        filled.buttonSize = .medium
        filled.image = UIImage(systemName: "g.circle")
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
    lazy var appleButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.title = "Contiune with apple "
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
        let st = UIStackView(arrangedSubviews: [emailButton,googleButton,appleButton])
        st.spacing = 12
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        return st
    }()
    
    
    // MARK: - 규정 안내 타이틀 UITextView로 바꿔야함
    private lazy var infoLabel: UILabel = {
        let text = "By tapping Continue, You agree to our Terms and \n acknowlege that you have read our Privacy Policy."
        let termRange = NSRange(location: 38, length: 5)
        let privacyRange =  NSRange(location: 84, length: 14)
        
        // NSAttributedString 생성
        let attributedString = NSMutableAttributedString(string: text)

        let termURL = URL(string: "https://www.apple.com")!
        let privacyURL = URL(string: "https://www.google.com")!

        attributedString.addAttribute(.link, value: termURL, range: termRange)
        attributedString.addAttribute(.link, value: privacyURL, range: privacyRange)
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        label.attributedText = attributedString
        return label
    }()
    
    // MARK: - 로그인 버튼
    private lazy var loginButton: UIButton = {
        let text = "Have an account? Log in"
        let range = NSRange(location: 17, length: 6)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range:range)
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(appNameLabel)
        view.addSubview(signUpLabel)
        view.addSubview(stackView)
        view.addSubview(infoLabel)
        view.addSubview(loginButton)
        
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            signUpLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 36),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.heightAnchor.constraint(equalToConstant: buttonHeight * 3 + 24)
        ])
    
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 36),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc func loginButtonTapped() {
        let logInVC = LogInViewController()
        logInVC.modalPresentationStyle = .fullScreen
        present(logInVC, animated: true)
    }

    @objc func emailButtonTapped() {
        print("email button tapped")
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true)
    }
}
