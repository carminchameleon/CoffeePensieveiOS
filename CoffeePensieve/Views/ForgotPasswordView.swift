//
//  ForgotPasswordView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/15.
//

import UIKit


class ForgotPasswordView: UIView {
    
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
        label.text = "Forgot password? \n It's okay!"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    
    // MARK: - 이메일 입력 안내 멘트
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your registered email below to receive \n password reset instruction"
        label.font = UIFont.systemFont(ofSize: 12)
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
    
    // MARK: - 다음 동작 버튼
    let continueButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Continue", for: .normal)
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
        emailTextField.delegate = self
    }
    
    func makeUI() {
        backgroundColor = .white
        
        emailTextField.setupLeftSideImage(imageViewName: "envelope")
        emailTextField.setupRightSideImage(imageViewName: "xmark.circle.fill", passed: false)
        emailTextField.becomeFirstResponder()
        
        
        addSubview(backButton)
        addSubview(mainLabel)
        addSubview(infoLabel)
        addSubview(emailTextFieldView)
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
            mainLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 18),
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: 0),
            emailTextField.bottomAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: 0),
            emailTextField.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 12),
            emailTextField.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: -12),
        ])
        
        
        emailTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextFieldView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            emailTextFieldView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            emailTextFieldView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            emailTextFieldView.heightAnchor.constraint(equalToConstant: textViewHeight)
        ])
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: 12),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            continueButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        emailTextField.rightViewMode = .never
    }
}

extension ForgotPasswordView : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailTextFieldView.layer.borderColor = #colorLiteral(red: 0.2705882353, green: 0.3294117647, blue: 0.4078431373, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailTextFieldView.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.7294117647, blue: 0.7921568627, alpha: 1)
    }
    
}
