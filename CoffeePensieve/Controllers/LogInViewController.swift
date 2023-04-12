//
//  LogInViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/09.
//

import UIKit

final class LogInViewController: UIViewController {

    private let textViewHeight: CGFloat = 48

    // MARK: - 뒤로가기 버튼
    private lazy var backButton: UIButton = {
        let button = UIButton(type:.custom)
        let iconImage = UIImage(systemName: "chevron.backward.circle")
        let resizedImage = iconImage?.resized(toWidth: 32) // 아이콘 사이즈 설정
        button.setImage(resizedImage, for: .normal)
        button.setImageTintColor(.grayColor400) // 아이콘 색 설정
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - 로그인 안내 타이틀
    private lazy var logInLabel: UILabel = {
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
    private lazy var emailTextField: UITextField = {
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
//        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
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
    private lazy var passwordTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 36
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = .clear
        tf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayColor400])
        tf.isSecureTextEntry = true
        tf.clearsOnBeginEditing = false
//        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)

        return tf
    }()
    
    // MARK: - 비밀번호 잊음 버튼
    private lazy var forgotButton: UIButton = {
        let text = "Forgot password?"
        let range = NSRange(location: 0, length: text.count)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(forgotButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 필드 스택뷰
    private lazy var textFieldStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView])
        st.spacing = 12
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        return st
    }()

    
    // MARK: TODO - 애니메이션 - 키보드 활성화에 따라서 보이거나 감춰지도록 하기
    // MARK: - 로그인 버튼
    private let logInButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.primaryColor300, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.isEnabled = false
        button.addTarget(LogInViewController.self, action: #selector(logInButtonTapped), for: .touchUpInside)
        return button
    }()

//https://medium.com/swlh/clickable-link-on-a-swift-label-or-textview-98bbb067451d
    let infoView: UITextView = {
        let view = UITextView()
        let text = "Your use of Coffee and Mood is subject to our Terms and Privacy Policy."
        view.text = text
        
        let termRange = NSRange(location: 46, length: 5)
        let privacyRange =  NSRange(location: 56, length: 14)
        let attributedString = NSMutableAttributedString(string: text)
        let termURL = URL(string: "https://www.apple.com")!

        attributedString.addAttribute(.link, value: termURL, range: termRange)
        attributedString.addAttribute(.link, value: termURL, range: privacyRange)
        view.attributedText = attributedString
        view.backgroundColor = .clear
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .black
        view.textAlignment = .center
        view.isSelectable = true
        view.dataDetectorTypes = .link
        
        return view
    }()

    
    
    // MARK: - 회원가입 버튼
    private lazy var signUpButton: UIButton = {
        let text = "Need an account? Sign Up"
        let range = NSRange(location: 17, length: 7)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range:range)
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
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
    
    // MARK: - 소셜 로그인 스택뷰
    lazy var socialStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [googleButton,appleButton])
        st.spacing = 12
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        return st
    }()
    
    
    lazy var forgotPasswordInfoTooltip: UILabel = {
    
        let boldAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12,weight: .bold) ]
        let regularAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        let regularText = NSAttributedString(string: "Please provide a ", attributes: regularAttribute)
        let boldText = NSAttributedString(string: "valid email", attributes: boldAttribute)
        let regularText1 = NSAttributedString(string: " first", attributes: regularAttribute)

        let newString = NSMutableAttributedString()
        
        newString.append(regularText)
        newString.append(boldText)
        newString.append(regularText1)
        
        var label = UILabel()
        label.textColor = .grayColor500
        label.backgroundColor = .grayColor100
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 6
        label.attributedText = newString
        return label
    }()
    
    lazy var forgotPasswordSuccessTooltip: UILabel = {
        var label = UILabel()
        label.text = "A temporary password has been sent to your email."
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .grayColor500
        label.backgroundColor = .grayColor100
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 6
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setUpNotification()
        makeUI()
    }

    
    // MARK: - 키보드 UI 활성화 부분
    var loginLabelTopConstraint: NSLayoutConstraint!
    var infoLabelTopConstraint: NSLayoutConstraint!
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpAction(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownAction(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func moveUpAction(_ notification: Notification){
        let keyboardHeight = getKeyboardHeight(notification: notification)
        infoLabelTopConstraint.constant = -keyboardHeight - 50
        loginLabelTopConstraint.constant = -180
        showLoginButton()
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func moveDownAction(_ notification: Notification){
       
        loginLabelTopConstraint.constant = -100
        infoLabelTopConstraint.constant = -150
        hideLoginButton()
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func hideLoginButton(){
        logInButton.isHidden = true
        socialStackView.isHidden = false
    }

    func showLoginButton(){
        logInButton.isHidden = false
        socialStackView.isHidden = true
    }

    
    private func makeUI() {
        emailTextField.setupLeftSideImage(imageViewName: "envelope")
        passwordTextField.setupLeftSideImage(imageViewName: "lock")
      
        hideLoginButton()
        forgotPasswordInfoTooltip.isHidden = true
        forgotPasswordSuccessTooltip.isHidden = true
        
        view.addSubview(backButton)
        view.addSubview(logInLabel)
        view.addSubview(textFieldStackView)
        view.addSubview(forgotButton)
        view.addSubview(socialStackView)
        view.addSubview(infoView)
        view.addSubview(signUpButton)
        view.addSubview(logInButton)
        
        view.addSubview(forgotPasswordInfoTooltip)
        view.addSubview(forgotPasswordSuccessTooltip)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        logInLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        forgotButton.translatesAutoresizingMaskIntoConstraints = false
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        socialStackView.translatesAutoresizingMaskIntoConstraints = false
        infoView.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordInfoTooltip.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordSuccessTooltip.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            backButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        loginLabelTopConstraint = logInLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        NSLayoutConstraint.activate([
            loginLabelTopConstraint,
            logInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInLabel.heightAnchor.constraint(equalToConstant: 30)
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
            textFieldStackView.topAnchor.constraint(equalTo: logInLabel.bottomAnchor, constant: 18),
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            textFieldStackView.heightAnchor.constraint(equalToConstant: textViewHeight * 2 + 12)
        ])
       
        
        NSLayoutConstraint.activate([
            forgotButton.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 16),
            forgotButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            forgotButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            forgotButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    
        NSLayoutConstraint.activate([
            socialStackView.topAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: 70),
            socialStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            socialStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            socialStackView.heightAnchor.constraint(equalToConstant: textViewHeight * 2 + 12)
        ])
        
        infoLabelTopConstraint =  infoView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)
        NSLayoutConstraint.activate([
            infoLabelTopConstraint,
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            infoView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            signUpButton.heightAnchor.constraint(equalToConstant: 48)
        ])
   
        NSLayoutConstraint.activate([
            logInButton.topAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: 20),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            logInButton.heightAnchor.constraint(equalToConstant: 48)
        ])
   
        NSLayoutConstraint.activate([
            forgotPasswordInfoTooltip.topAnchor.constraint(equalTo: textFieldStackView.topAnchor, constant: -54),
            forgotPasswordInfoTooltip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            forgotPasswordInfoTooltip.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            forgotPasswordInfoTooltip.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            forgotPasswordSuccessTooltip.topAnchor.constraint(equalTo: textFieldStackView.topAnchor, constant: -54),
            forgotPasswordSuccessTooltip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            forgotPasswordSuccessTooltip.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            forgotPasswordSuccessTooltip.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        forgotPasswordInfoTooltip.isHidden = true
    }

    // MARK: - TODO : 다음 작업
    @objc private func logInButtonTapped() {
        // TODO 기존에 있는 회원인지 아닌지 확인 필요
        // 다음 단계로 넘어가게 할 것인지 아닌지 체크
    }
    
    
    // MARK: - 회원가입 뷰로 이동
    @objc private func signUpButtonTapped() {
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true)
    }
    
    // MARK: - 뒤로 돌아가기
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - 로그인 입력 필드 관련 로직 추가 필요
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        print("hello")
    }
    
    // MARK: - 비밀번호 까먹었음 버튼
    // 1. 이메일 필드가 아예 비워져 있는 경우 -> 이메일 채우고 클릭해줘
    // 2. 이메일 입력했지만 형식이 맞지 않는 경우 -> 이메일 형식을 확인 해줘
    // 3. 이메일 형식 맞을 경우 -> 서버 요청
    // 3-1. 존재하는 회원이 아니야
    // 3-2. 이메일 보낸 것 성공했어.
    // 다른곳 클릭하면 안보여주기
    // 키보드 입력되는 상태면 안보여주기 추가!
    @objc private func forgotButtonTapped() {
        
        let text = emailTextField.text ?? ""
        
        if text == "" {
            forgotPasswordInfoTooltip.isHidden = false
            return
        }
        
        if !isValidEmail(text) {
            forgotPasswordInfoTooltip.isHidden = false
            return
        }
        
        forgotPasswordSuccessTooltip.isHidden = false
        emailTextField.text = ""
    }
    
    
}


extension LogInViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        forgotPasswordInfoTooltip.isHidden = true
        forgotPasswordSuccessTooltip.isHidden = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        forgotPasswordInfoTooltip.isHidden = true
        forgotPasswordSuccessTooltip.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        forgotPasswordInfoTooltip.isHidden = true
        forgotPasswordSuccessTooltip.isHidden = true
            return true
    }
    
  
}


func getKeyboardHeight(notification: Notification) -> CGFloat {
    if let userInfo = notification.userInfo {
        if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            return keyboardHeight
        }
    }
    return 0
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
