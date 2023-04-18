//
//  ForgotPasswordViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/15.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    var forgotPasswordView = ForgotPasswordView()
    
    override func loadView() {
        view = forgotPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        
    }
    
    func addTargets() {
        forgotPasswordView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchDown)
        forgotPasswordView.continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchDown)
        forgotPasswordView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }

    // MARK: - 뒤로 돌아가기
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    // 서버로 전송, 성공시 다음 단계로 화면 이동
    // 실패시 이메일이 없음 혹은 안내 멘트에 따라서 알려주기
    // 전송 횟수 정해놓을 것 (어뷰징 방지) -> 어떻게 할 수 있을까...?
    
    // MARK: - 비밀번호 코드 전송 화면으로 이동
    // 유효한 이메일인지 확인
    // 백에서 이메일 코드 생성 -> 전송 후 알려줌
    // 
    @objc private func continueButtonTapped() {
        guard let email = forgotPasswordView.emailTextField.text else { return }
        
        let resetVC = ResetPasswordViewController()
        resetVC.modalPresentationStyle = .currentContext
        resetVC.userEmail = email
        present(resetVC, animated: true)
        
        
        
    }
    
    @objc private func textFieldEditingChanged() {
        guard let email = forgotPasswordView.emailTextField.text else { return }
    
        if email.count > 0 {
            forgotPasswordView.emailTextField.rightViewMode = .always
        }

        // 이메일 검증 원래 되어야 함 (나중에 풀 것)
        if isValidEmail(email) {
            forgotPasswordView.emailTextField.setupRightSideImage(imageViewName: "checkmark.circle.fill", passed: true)
            forgotPasswordView.continueButton.isEnabled = true
            forgotPasswordView.continueButton.setTitleColor(UIColor.primaryColor500, for: .normal)

        } else {
            forgotPasswordView.emailTextField.setupRightSideImage(imageViewName: "xmark.circle.fill", passed: false)
            forgotPasswordView.continueButton.isEnabled = false
            forgotPasswordView.continueButton.setTitleColor(UIColor.primaryColor300, for: .normal)
        }
    }


    // MARK: - TODO : Refactoring 공통 함수 부분으로 옮겨 놓을 것
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
