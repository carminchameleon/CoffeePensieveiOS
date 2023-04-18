//
//  ResetPasswordViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/15.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    let resetPasswordView = ResetPasswordView()
    var userEmail: String = ""
    
    override func loadView() {
        view = resetPasswordView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    
    func addTargets() {
        resetPasswordView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchDown)
        resetPasswordView.codeTextField.addTarget(self, action: #selector(codeTextFieldEditing), for: .editingChanged)
        resetPasswordView.codeTextField.addTarget(self, action: #selector(passwordTextFieldEditing), for: .editingChanged)
        resetPasswordView.passwordTextField.addTarget(self, action: #selector(passwordTextFieldEditing), for: .editingChanged)
        resetPasswordView.confirmPasswordTextField.addTarget(self, action: #selector(passwordTextFieldEditing), for: .editingChanged)
        resetPasswordView.continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchDown)
    }
    
    // MARK: - 뒤로 돌아가기
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    
    // MARK: - code 4글자이면 다음 필드로 넘어가게 하기
    @objc private func codeTextFieldEditing() {
        guard let code =  resetPasswordView.codeTextField.text else { return }
        if code.count == 4 {
            resetPasswordView.passwordTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - 텍스트필드 제출 조건 확인하기
    @objc private func passwordTextFieldEditing() {
        guard let code = resetPasswordView.codeTextField.text else { return }
        
        guard let firstPW = resetPasswordView.passwordTextField.text else { return }
        guard let secondPW = resetPasswordView.confirmPasswordTextField.text else { return }
        
        
        let firstCondition = isValidPassword(firstPW)
        let secondCondition = firstPW == secondPW
        let thirdCondition = code.count == 4
        
        if firstCondition && secondCondition && thirdCondition {
            resetPasswordView.continueButton.isEnabled = true
            resetPasswordView.continueButton.setTitleColor(UIColor.primaryColor500, for: .normal)
        } else {
            resetPasswordView.continueButton.isEnabled = false
            resetPasswordView.continueButton.setTitleColor(UIColor.primaryColor300, for: .normal)
        }
    }
    
    @objc private func continueButtonTapped() {
        guard let code = resetPasswordView.codeTextField.text else { return }
        guard let newPassword = resetPasswordView.passwordTextField.text else { return }
        // 세가지 가지고 서버에 보내기
        // email
        // digitCode
        // newPassword
        print(code, newPassword)
        let successVC = ResetPasswordSuccessViewController()
        successVC.modalPresentationStyle = .fullScreen
        present(successVC, animated: true)
        
    }
    

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d@$!%*#?&]{8,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }

    
}
