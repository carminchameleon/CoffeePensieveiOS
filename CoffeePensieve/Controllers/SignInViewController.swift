//
//  SignInViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/14.
//

import UIKit
import FirebaseAuth

final class SignInViewController: UIViewController {
    
    private let signInView = SignInView()
    private let networkManager = AuthNetworkManager.shared
    
    override func loadView() {
        view = signInView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    
    private func addTargets() {
        signInView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchDown)
        signInView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        signInView.passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        signInView.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchDown)
        signInView.forgotButton.addTarget(self, action: #selector(forgotPassword), for: .touchDown)
    }
    
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
    
    private func initTextField() {
        signInView.emailTextField.text = ""
        signInView.passwordTextField.text = ""
        signInView.emailTextField.becomeFirstResponder()
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        guard let password = signInView.passwordTextField.text else { return }
        guard let email = signInView.emailTextField.text else { return }
        
        if Common.isValidEmail(email) && password != "" {
            signInView.signInButton.isEnabled = true
//            signInView.signInButton.setTitleColor(UIColor.primaryColor500, for: .normal)

        } else {
            signInView.signInButton.isEnabled = false
//            signInView.signInButton.setTitleColor(UIColor.primaryColor300, for: .normal)
        }
    }
}
