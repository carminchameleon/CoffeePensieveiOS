//
//  ResetPasswordView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/15.
//

import UIKit

class ResetPasswordView: UIView {

    
    private let textViewHeight: CGFloat = 48
    private let buttonHeight: CGFloat = 56
    
    var isTouched = false
    
    // MARK: - 뒤로가기 버튼
    lazy var backButton: UIButton = {
        let button = UIButton(type:.custom)
        let iconImage = UIImage(systemName: "chevron.backward.circle")
        let resizedImage = iconImage?.resized(toWidth: 32) // 아이콘 사이즈 설정
        button.setImage(resizedImage, for: .normal)
        button.setImageTintColor(.grayColor400) // 아이콘 색 설정
        return button
    }()
    
    // MARK: - 비밀번호 까먹음 안내 멘트
    private lazy var mainLabel: UILabel = {
        var label = UILabel()
        label.text = "Reset your password"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    
    // MARK: - 이메일 입력 안내 멘트
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "We have sent a four digit code on your email."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - 이메일 입력 안내 멘트
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.text = "Tips! The password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, and one digit."
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .primaryColor500
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - 인증 코드 입력 뷰
    private lazy var codeTextFieldView: UIView =  {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        view.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.7294117647, blue: 0.7921568627, alpha: 1)
        view.layer.borderWidth = 1
        view.backgroundColor = .clear
        view.addSubview(codeTextField)
        return view
    }()
    
    
    //MARK: - 인증 코드 입력 필드
    lazy var codeTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 36
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = .clear
        tf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tf.keyboardType = .numberPad
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.attributedPlaceholder = NSAttributedString(string: "Four Digit Code", attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayColor400])
        tf.isSecureTextEntry =  false // 나중에 바꿔줘야함
        tf.clearsOnBeginEditing = false
        return tf
    }()
    
    // MARK: - 인증 코드 입력 뷰
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
    
    //MARK: - 인증 코드 입력 필드
    lazy var passwordTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 36
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = .clear
        tf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayColor400])
        tf.isSecureTextEntry =  false // 나중에 바꿔줘야함
        tf.clearsOnBeginEditing = false
        
        
        return tf
    }()
    
    // MARK: - 인증 코드 입력 뷰
    private lazy var confirmPasswordTextFieldView: UIView =  {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        view.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.7294117647, blue: 0.7921568627, alpha: 1)
        view.layer.borderWidth = 1
        view.backgroundColor = .clear
        view.addSubview(confirmPasswordTextField)
        return view
    }()
    
    //MARK: - 인증 코드 입력 필드
    lazy var confirmPasswordTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 36
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = .clear
        tf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayColor400])
        return tf
    }()
    
    lazy var stackView: UIStackView = {
        var st = UIStackView(arrangedSubviews: [codeTextFieldView, passwordTextFieldView, confirmPasswordTextFieldView])
        st.spacing = 12
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        return st
    }()
    
    // MARK: - 다음 동작 버튼
    let continueButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.primaryColor300, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.isEnabled = false
        return button
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
        codeTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }

    func makeUI() {
        backgroundColor = .white

        codeTextField.becomeFirstResponder()


        addSubview(backButton)
        addSubview(mainLabel)
        addSubview(infoLabel)
        addSubview(tipLabel)
        addSubview(stackView)
        addSubview(continueButton)

        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            backButton.heightAnchor.constraint(equalToConstant: 30),
        ])

        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 12),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            infoLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tipLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8),
            tipLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            tipLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            tipLabel.heightAnchor.constraint(equalToConstant: 40)
        ])

        
        codeTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeTextField.topAnchor.constraint(equalTo: codeTextFieldView.topAnchor, constant: 0),
            codeTextField.bottomAnchor.constraint(equalTo: codeTextFieldView.bottomAnchor, constant: 0),
            codeTextField.leadingAnchor.constraint(equalTo: codeTextFieldView.leadingAnchor, constant: 12),
            codeTextField.trailingAnchor.constraint(equalTo: codeTextFieldView.trailingAnchor, constant: -12),
        ])
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 0),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: 0),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 12),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -12),
        ])
        
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordTextFieldView.topAnchor, constant: 0),
            confirmPasswordTextField.bottomAnchor.constraint(equalTo: confirmPasswordTextFieldView.bottomAnchor, constant: 0),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: confirmPasswordTextFieldView.leadingAnchor, constant: 12),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: confirmPasswordTextFieldView.trailingAnchor, constant: -12),
        ])
        
        

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: tipLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            stackView.heightAnchor.constraint(equalToConstant: textViewHeight * 3 + 24)
        ])

        continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            continueButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])

    }
}
//
extension ResetPasswordView : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == codeTextField {
            codeTextFieldView.layer.borderColor = #colorLiteral(red: 0.2705882353, green: 0.3294117647, blue: 0.4078431373, alpha: 1)
        } else if textField == passwordTextField  {
            passwordTextFieldView.layer.borderColor = #colorLiteral(red: 0.2705882353, green: 0.3294117647, blue: 0.4078431373, alpha: 1)
        } else {
            confirmPasswordTextFieldView.layer.borderColor = #colorLiteral(red: 0.2705882353, green: 0.3294117647, blue: 0.4078431373, alpha: 1)
        }
    }
    
    // 텍스트 필드 입력 종료
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == codeTextField {
            codeTextFieldView.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.7294117647, blue: 0.7921568627, alpha: 1)
        } else if textField == passwordTextField  {
            passwordTextFieldView.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.7294117647, blue: 0.7921568627, alpha: 1)
        } else {
            confirmPasswordTextFieldView.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.7294117647, blue: 0.7921568627, alpha: 1)
        }
    }
    // 엔터 눌렀을 대 넘어가는 것
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == codeTextField && codeTextField.text != "" {
                passwordTextField.becomeFirstResponder() // 다음 텍스트필드로 포커스 이동
        } else if textField == passwordTextField && passwordTextField.text != "" {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            confirmPasswordTextField.resignFirstResponder() // 키보드 숨김
        }
            return true
    }
    
    
    
    // Use this if you have a UITextView
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        if textField == codeTextField {
            let currentText = textField.text ?? ""

            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }

            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // make sure the result is under 16 characters
            return updatedText.count <= 4
        }
        return true
    }
}
