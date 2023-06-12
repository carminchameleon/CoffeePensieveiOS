//
//  SignUpView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/14.
//

import UIKit

final class SignUpView: UIView {

    private let textViewHeight: CGFloat = 48
    private let buttonHeight: CGFloat = 56
    
    
    var isEmailPassed: Bool = false {
        willSet {
            if newValue && isPasswordPassed {
                changeButtonStatus(true)
            } else {
                changeButtonStatus(false)
            }
        }
    }
    
    var isPasswordPassed: Bool = false {
        willSet {
            if newValue && isEmailPassed {
                changeButtonStatus(true)
            } else {
                changeButtonStatus(false)
            }
        }
    }
    
    // MARK: - 각 필드 상태에 따라 버튼 상태 업데이트
    private func changeButtonStatus(_ isEnable: Bool) {
        if isEnable {
            signUpButton.isEnabled = true
            signUpButton.setTitleColor(UIColor.primaryColor500, for: .normal)
        } else {
            signUpButton.isEnabled = false
            signUpButton.setTitleColor(UIColor.primaryColor300, for: .normal)
        }
    }
    
    // MARK: - 뒤로가기 버튼
    lazy var backButton: UIButton = {
        let button = UIButton(type:.custom)
        let iconImage = UIImage(systemName: "chevron.backward.circle")
        let resizedImage = iconImage?.resized(toWidth: 36) // 아이콘 사이즈 설정
        button.setImage(resizedImage, for: .normal)
        button.setImageTintColor(.primaryColor500) // 아이콘 색 설정
        return button
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
        tf.textContentType = .oneTimeCode
        tf.spellCheckingType = .no
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayColor400])
        tf.isSecureTextEntry = true
        tf.clearsOnBeginEditing = false
        return tf
    }()
    
    // MARK: - 회원가입 버튼
    let signUpButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.primaryColor300, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        // 테스트 용으로 수정
        button.isEnabled = true
        return button
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
    
    // MARK: - 스택뷰
    private lazy var stackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView])
        st.spacing = 12
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        return st
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDelegates()
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - 오토레이아웃
    private func makeUI() {
        backgroundColor = .white
        emailTextField.becomeFirstResponder()
        
        addSubview(stackView)
        addSubview(signUpLabel)
        addSubview(infoLabel)
        addSubview(policyLabel)
        addSubview(backButton)
        addSubview(signUpButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        policyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.setupLeftSideImage(imageViewName: "envelope")
        emailTextField.setupRightSideImage(imageViewName: "xmark.circle.fill", passed: false)
        passwordTextField.setupLeftSideImage(imageViewName: "lock")
        passwordTextField.setupRightSideImage(imageViewName: "xmark.circle.fill", passed: false)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            backButton.heightAnchor.constraint(equalToConstant: 36),
        ])
        
        NSLayoutConstraint.activate([
            signUpLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            signUpLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpLabel.heightAnchor.constraint(equalToConstant: 60)
        ])

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
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            stackView.heightAnchor.constraint(equalToConstant: textViewHeight*2 + 12)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12),
            signUpButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            signUpButton.heightAnchor.constraint(equalToConstant: 56)
        ])

        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            policyLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 0),
            policyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

        emailTextField.rightViewMode = .never
        passwordTextField.rightViewMode = .never
       
    }
    
    // MARK: - 바깥쪽 누르면 키보드 내려가는 것
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

}


extension SignUpView: UITextFieldDelegate {

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
