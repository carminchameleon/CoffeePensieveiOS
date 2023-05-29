//
//  SignInView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/14.
//

import UIKit

class SignInView: UIView {
    private let textViewHeight: CGFloat = 48
    private let buttonHeight: CGFloat = 56
    
    // MARK: - 뒤로가기 버튼
    lazy var backButton: UIButton = {
        let button = UIButton(type:.custom)
        let iconImage = UIImage(systemName: "chevron.backward.circle")
        let resizedImage = iconImage?.resized(toWidth: 32) // 아이콘 사이즈 설정
        button.setImage(resizedImage, for: .normal)
        button.setImageTintColor(.grayColor400) // 아이콘 색 설정
        return button
    }()
    
    
    // MARK: - 회원가입 안내 타이틀
    private lazy var signInLabel: UILabel = {
        var label = UILabel()
        label.text = "Log into your account"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - 이메일 입력 뷰
    private lazy var emailTextFieldView: UIView =  {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        view.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.7294117647, blue: 0.7921568627, alpha: 1)
        view.layer.borderWidth = 1
        view.backgroundColor = .clear
        view.addSubview(emailTextField)
        return view
    }()
    
    //MARK: - 이메일 입력 필드
    lazy var emailTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 36
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = .clear
        tf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayColor400])
        return tf
    }()
    
    
    
    // MARK: - 패스워드 입력 뷰
    private lazy var passwordTextFieldView: UIView =  {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        view.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.7294117647, blue: 0.7921568627, alpha: 1)
        view.layer.borderWidth = 1
        view.backgroundColor = .clear
        view.addSubview(passwordTextField)
        return view
    }()
    
    // MARK: - 비밀번호 입력 필드
    lazy var passwordTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 36
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = .clear
        tf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayColor400])
        tf.isSecureTextEntry =  false // 나중에 바꿔줘야함
        tf.clearsOnBeginEditing = false
        return tf
    }()
    
    
    // MARK: - 비밀번호 까먹음
    lazy var forgotButton: UIButton = {
        let text = "Forgot password?"
        let range = NSRange(location: 0, length: text.count)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range:range)
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    
    // MARK: - 로그인
    let signInButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.primaryColor300, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.isEnabled = false
        return button
    }()
    
    
    
    // MARK: - 회원가입 안내 타이틀
    lazy var googleButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.title = "Google"
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
        filled.title = "Apple "
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
    
    
    
    lazy var textFieldStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView])
        st.spacing = 12
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        return st
    }()
    
    
    
    lazy var buttonStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [googleButton,appleButton])
        st.spacing = 12
        st.axis = .horizontal
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        makeUI()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setUp() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func makeUI(){
        backgroundColor = .white
        
        addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            backButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        addSubview(signInLabel)
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 48),
            signInLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            signInLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            signInLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        emailTextField.setupLeftSideImage(imageViewName: "envelope")
        passwordTextField.setupLeftSideImage(imageViewName: "lock")
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: 0),
            emailTextField.bottomAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: 0),
            emailTextField.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 12),
            emailTextField.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: -12),
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 0),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: 0),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 12),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -12),
        ])
        
        addSubview(textFieldStackView)
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldStackView.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 20),
            textFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            textFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            textFieldStackView.heightAnchor.constraint(equalToConstant: textViewHeight*2 + 12)
        ])
        
        addSubview(forgotButton)
        forgotButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forgotButton.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 12),
            forgotButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            forgotButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            forgotButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        
        addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: 12),
            signInButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            signInButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            signInButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        
        addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 12),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

extension SignInView: UITextFieldDelegate {
    // 텍스트필드 입력 시작
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextFieldView.layer.borderColor = #colorLiteral(red: 0.2705882353, green: 0.3294117647, blue: 0.4078431373, alpha: 1)
        } else {
            passwordTextFieldView.layer.borderColor = #colorLiteral(red: 0.2705882353, green: 0.3294117647, blue: 0.4078431373, alpha: 1)
        }
    }
    
    // 텍스트 필드 입력 종료
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextFieldView.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.7294117647, blue: 0.7921568627, alpha: 1)
        } else {
            passwordTextFieldView.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.7294117647, blue: 0.7921568627, alpha: 1)
        }
    }
    
    // 엔터 눌렀을 대 넘어가는 것
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField && emailTextField.text != "" {
                passwordTextField.becomeFirstResponder() // 다음 텍스트필드로 포커스 이동
            } else {
                passwordTextField.resignFirstResponder() // 키보드 숨김
            }
            return true
    }
}
