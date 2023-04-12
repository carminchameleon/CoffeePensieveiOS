//
//  SignUpViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/08.
//

/**
 키보드 활성화 시 전체 움직임 추가
 아이콘 비율 조정
 */

import UIKit
class SignUpViewController: UIViewController {
    
    private let textViewHeight: CGFloat = 48
    
    private var isEmailPassed: Bool = false {
            willSet {
                if newValue && isPasswordPassed {
                    changeButtonStatus(true)
                } else {
                    changeButtonStatus(false)
                }
            }
    }
    
    private var isPasswordPassed: Bool = false {
            willSet {
                if newValue && isEmailPassed {
                    changeButtonStatus(true)
                } else {
                    changeButtonStatus(false)
                }
            }
    }

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
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)

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
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()

    // MARK: - 회원가입 버튼
    private let signUpButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.primaryColor300, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 1, alpha: 1)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.isEnabled = false
        button.addTarget(SignUpViewController.self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - 규정 안내 타이틀
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
    
    // MARK: - 스택뷰
    private lazy var stackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView,signUpButton])
        st.spacing = 12
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        return st
    }()

    private lazy var containerStackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [signUpLabel, stackView, infoLabel])
        st.axis = .vertical
        return st
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        makeUI()
        setUpNotification()
    }

    // MARK: - 키보드 UI 활성화 부분
    var infoLabelTopConstraint: NSLayoutConstraint!
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpAction), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownAction), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func moveUpAction(){
        infoLabelTopConstraint.constant = -150
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func moveDownAction(){
        infoLabelTopConstraint.constant = -30
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - 오토레이아웃
    private func makeUI() {
        emailTextField.becomeFirstResponder()
        
        view.addSubview(stackView)
        view.addSubview(signUpLabel)
        view.addSubview(infoLabel)
        view.addSubview(backButton)
        
        view.backgroundColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.setupLeftSideImage(imageViewName: "envelope")
        emailTextField.setupRightSideImage(imageViewName: "xmark.circle.fill", passed: false)
        passwordTextField.setupLeftSideImage(imageViewName: "lock")
        passwordTextField.setupRightSideImage(imageViewName: "xmark.circle.fill", passed: false)
        
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            backButton.heightAnchor.constraint(equalToConstant: 30),
        ])

        infoLabelTopConstraint = signUpLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30)
        
        NSLayoutConstraint.activate([
            infoLabelTopConstraint,
            signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            stackView.heightAnchor.constraint(equalToConstant: textViewHeight*3 + 24)
        ])

        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
       
    }
    
    // MARK: - 바깥쪽 누르면 키보드 내려가는 것
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
    
    // MARK: - 뒤로 돌아가기
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - TODO : 다음 작업
    @objc private func signUpButtonTapped() {
        // TODO 기존에 있는 회원인지 아닌지 확인 필요
        // 다음 단계로 넘어가게 할 것인지 아닌지 체크
        
    }
    
}




extension SignUpViewController: UITextFieldDelegate {

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
    
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        guard let placeholder = textField.placeholder else { return }
        guard let text = textField.text else { return }
        
        if placeholder == "Email" {
            if isValidEmail(text) {
                emailTextField.setupRightSideImage(imageViewName: "checkmark.circle.fill", passed: true)
                isEmailPassed = true
            } else {
                emailTextField.setupRightSideImage(imageViewName: "xmark.circle.fill", passed: false)
                isEmailPassed = false
            }
        } else {
            if isValidPassword(text) {
                passwordTextField.setupRightSideImage(imageViewName: "checkmark.circle.fill", passed: true)
                isPasswordPassed = true
            } else {
                passwordTextField.setupRightSideImage(imageViewName: "xmark.circle.fill", passed: false)
                isPasswordPassed = false
            }
        }
    }
    
    
    
    // MARK: - TODO : Refactoring 공통 함수 부분으로 옮겨 놓을 것
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    // MARK: - TODO : Refactoring 공통 함수 부분으로 옮겨 놓을 것
    /*
     최소 8자리 이상
     영어 대문자, 소문자 또는 숫자 중 하나 이상 포함
     특수문자 (@, $, !, %, *, #, ?, &)를 포함할 수 있지만 필수는 아님
     */
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d@$!%*#?&]{8,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    
}



extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIButton{
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }
}



extension UITextField {
    func setupLeftSideImage(imageViewName:String) {
        // 아이콘 자체
        let imageView = UIImageView(frame: CGRect(x:2,y:2,width:20,height: 20))
        imageView.image = UIImage(systemName: imageViewName)
        // 아이콘 감싸는 것
        let imageViewContainerView = UIView(frame: CGRect(x:0, y:0, width: 32, height: 24))
        imageViewContainerView.addSubview(imageView)
        imageView.tintColor = #colorLiteral(red: 0.2705882353, green: 0.3294117647, blue: 0.4078431373, alpha: 1)
        leftView = imageViewContainerView
        leftViewMode = .always
    
    }
    
    func setupRightSideImage(imageViewName:String, passed: Bool) {
        // 아이콘 자체
        let imageView = UIImageView(frame: CGRect(x:0,y:0,width:20,height: 20))
        imageView.image = UIImage(systemName: imageViewName)
        // 아이콘 감싸는 것
        let imageViewContainerView = UIView(frame: CGRect(x:0, y:0, width: 20, height: 20))
        imageViewContainerView.addSubview(imageView)
        
        rightView = imageViewContainerView
        rightViewMode = .always
        
        if passed {
            imageView.tintColor = UIColor.primaryColor400
        } else {
            imageView.tintColor = UIColor.redColor400
        }
    }
}
