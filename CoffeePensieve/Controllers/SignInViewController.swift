//
//  SignInViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/14.
//

import UIKit

// 구현 리스트
// 커서 활성화 -> textfield 클릭시 디자인 (0)
// 필드 채워졌을 시 로그인 버튼 활성화 (0)
// textField 값 받아오기 (0)
// forgot password 버튼 이동
// signUp 버튼 이동
// 소셜 로그인 구현

class SignInViewController: UIViewController {
    
    let signInView = SignInView()
    
    override func loadView() {
        view = signInView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    
    func addTargets() {
        signInView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchDown)
        signInView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchDown)
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
        let id = signInView.emailTextField.text!
        let password = signInView.passwordTextField.text!
        print("id: \(id), password: \(password)")
        // 경고를 어떻게 할 것인지 고민 필요할 것 같음.
        // 알림창 띄울 것
    }
    
    // MARK: - 회원가입 버튼
    // 네비게이션 적용 해야 할 것
    @objc private func signUpButtonTapped() {
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true)
    }
    
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        guard let password = signInView.passwordTextField.text else { return }
        guard let email = signInView.emailTextField.text else { return }
        
        // 이메일의 경우 이메일 형식에 맞아야 함
        if isValidEmail(email) && password != "" {
            print("통과")
            signInView.signInButton.isEnabled = true
            signInView.signInButton.setTitleColor(UIColor.primaryColor500, for: .normal)

        } else {
            print("탈락")
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
