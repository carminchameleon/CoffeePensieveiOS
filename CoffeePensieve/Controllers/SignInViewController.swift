//
//  SignInViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/14.
//

import UIKit
import FirebaseAuth

// 구현 리스트
// 커서 활성화 -> textfield 클릭시 디자인 (0)
// 필드 채워졌을 시 로그인 버튼 활성화 (0)
// textField 값 받아오기 (0)
// forgot password 버튼 이동
// signUp 버튼 이동
// 소셜 로그인 구현

class SignInViewController: UIViewController {
    
    let signInView = SignInView()
    let networkManager = AuthNetworkManager.shared
    
    override func loadView() {
        view = signInView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    
    func addTargets() {
        signInView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchDown)
        signInView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        signInView.passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        signInView.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchDown)
        signInView.forgotButton.addTarget(self, action: #selector(forgotPassword), for: .touchDown)
    }
    
    // MARK: - 뒤로 돌아가기
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func forgotPassword() {
        let forgotVC = ForgotPasswordViewController()
        forgotVC.modalPresentationStyle = .fullScreen
        present(forgotVC, animated: true)
    }
    
    @objc private func signInButtonTapped() {
        guard let email = signInView.emailTextField.text else { return }
        guard let password = signInView.passwordTextField.text else { return }
        
        networkManager.signIn(email: email, password: password) { [weak self] error in
            guard let strongSelf = self else { return }

            let alert = UIAlertController(title: "Please try again...", message: "The email and password you entered did not match our records. Please double-check and try again", preferredStyle: .alert)
            let tryAgain = UIAlertAction(title: "Try again", style: .default)
            
            alert.addAction(tryAgain)
            strongSelf.initTextField()
            strongSelf.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func initTextField() {
        signInView.emailTextField.text = ""
        signInView.passwordTextField.text = ""
        signInView.emailTextField.becomeFirstResponder()
    }
    
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        guard let password = signInView.passwordTextField.text else { return }
        guard let email = signInView.emailTextField.text else { return }
        
        // 이메일의 경우 이메일 형식에 맞아야 함
        if isValidEmail(email) && password != "" {
            signInView.signInButton.isEnabled = true
            signInView.signInButton.setTitleColor(UIColor.primaryColor500, for: .normal)

        } else {
            signInView.signInButton.isEnabled = false
            signInView.signInButton.setTitleColor(UIColor.primaryColor300, for: .normal)
        }
    }
    
    
    // MARK: - TODO : Refactoring 공통 함수 부분으로 옮겨 놓을 것
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
