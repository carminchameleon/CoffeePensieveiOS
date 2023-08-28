//
//  ForgotPasswordViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/15.
//

import UIKit
import FirebaseAuth

final class ForgotPasswordViewController: UIViewController {
    private let forgotPasswordView = ForgotPasswordView()
    private let networkManager = AuthNetworkManager.shared
    
    override func loadView() {
        view = forgotPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    
    private func addTargets() {
        forgotPasswordView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchDown)
        forgotPasswordView.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchDown)
        forgotPasswordView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func submitButtonTapped() {
        guard let email = forgotPasswordView.emailTextField.text else { return }
        networkManager.forgotPassword(email: email) {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let successMessage):
                AlertManager.showTextAlert(on: strongSelf, title: successMessage, message: "You will receive a password reset email shortly") {
                    strongSelf.dismiss(animated: true)
                }
            case .failure(let error):
                AlertManager.showTextAlert(on: strongSelf, title: "Sorry", message: error.localizedDescription) {
                    strongSelf.dismiss(animated: true)
                }
            }
        }
    }
    
    @objc private func textFieldEditingChanged() {
        guard let email = forgotPasswordView.emailTextField.text else { return }
    
        if email.count > 0 {
            forgotPasswordView.emailTextField.rightViewMode = .always
        }

        if Common.isValidEmail(email) {
            forgotPasswordView.emailTextField.setupRightSideImage(imageViewName: "checkmark.circle.fill", passed: true)
            forgotPasswordView.submitButton.isEnabled = true
        } else {
            forgotPasswordView.emailTextField.setupRightSideImage(imageViewName: "xmark.circle.fill", passed: false)
            forgotPasswordView.submitButton.isEnabled = false
        }
    }

}
