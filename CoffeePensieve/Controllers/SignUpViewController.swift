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
        
    let signUpView = SignUpView()

    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    
    func addTargets() {
        signUpView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        signUpView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        signUpView.passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        signUpView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        guard let placeholder = textField.placeholder else { return }
        guard let text = textField.text else { return }
        if text.count == 0 {
            textField.rightViewMode = .never
        } else {
            textField.rightViewMode = .always
        }
        
        if placeholder == "Email" {
            if isValidEmail(text) {
                signUpView.emailTextField.setupRightSideImage(imageViewName: "checkmark.circle.fill", passed: true)
                signUpView.isEmailPassed = true
            } else {
                signUpView.emailTextField.setupRightSideImage(imageViewName: "xmark.circle.fill", passed: false)
                signUpView.isEmailPassed = false
            }
        } else {
            if isValidPassword(text) {
                signUpView.passwordTextField.setupRightSideImage(imageViewName: "checkmark.circle.fill", passed: true)
                signUpView.isPasswordPassed = true
            } else {
                signUpView.passwordTextField.setupRightSideImage(imageViewName: "xmark.circle.fill", passed: false)
                signUpView.isPasswordPassed = false
            }
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
        
        let firstProfileVC = FirstProfileGreetingViewController()
        firstProfileVC.modalPresentationStyle = .fullScreen
        firstProfileVC.modalTransitionStyle = .crossDissolve
        present(firstProfileVC, animated: true)
        
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


