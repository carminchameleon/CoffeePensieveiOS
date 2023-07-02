//
//  ForgotPasswordViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/15.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    var forgotPasswordView = ForgotPasswordView()
    let networkManager = AuthNetworkManager.shared
    
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

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func continueButtonTapped() {
        guard let email = forgotPasswordView.emailTextField.text else { return }
        networkManager.forgotPassword(email: email) {[weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case .success(let successMessage):
                let successAlert = UIAlertController(title: successMessage, message: "You will receive a password reset email shortly", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .default) { action in
                    strongSelf.dismiss(animated: true)
                }
                successAlert.addAction(okayAction)
                strongSelf.present(successAlert, animated: true, completion: nil)
            case .failure(let error):
                let failAlert = UIAlertController(title: "Sorry", message: error.localizedDescription, preferredStyle: .alert)
               let okayAction = UIAlertAction(title: "Okay", style: .default) {action in
                   strongSelf.dismiss(animated: true)
               }
               failAlert.addAction(okayAction)
               strongSelf.present(failAlert, animated: true, completion: nil)
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
            forgotPasswordView.continueButton.isEnabled = true
            forgotPasswordView.continueButton.setTitleColor(UIColor.primaryColor500, for: .normal)

        } else {
            forgotPasswordView.emailTextField.setupRightSideImage(imageViewName: "xmark.circle.fill", passed: false)
            forgotPasswordView.continueButton.isEnabled = false
            forgotPasswordView.continueButton.setTitleColor(UIColor.primaryColor300, for: .normal)
        }
    }

}
