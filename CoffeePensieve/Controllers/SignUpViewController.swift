//
//  SignUpViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/08.
//


import UIKit
import Firebase
import SafariServices

final class SignUpViewController: UIViewController {
        
    private let signUpView = SignUpView()

    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    
    private func addTargets() {
        signUpView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        signUpView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        signUpView.passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        signUpView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        let tapGestureForTerms = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped))
        let tapGestureForPolicy = UITapGestureRecognizer(target: self, action: #selector(policyLabelTapped))

        signUpView.infoLabel.isUserInteractionEnabled = true
        signUpView.infoLabel.addGestureRecognizer(tapGestureForTerms)
        signUpView.policyLabel.isUserInteractionEnabled = true
        signUpView.policyLabel.addGestureRecognizer(tapGestureForPolicy)        
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
            if Common.isValidEmail(text) {
                signUpView.emailTextField.setupRightSideImage(imageViewName: "checkmark.circle.fill", passed: true)
                signUpView.isEmailPassed = true
            } else {
                signUpView.emailTextField.setupRightSideImage(imageViewName: "xmark.circle.fill", passed: false)
                signUpView.isEmailPassed = false
            }
        } else {
            if Common.isValidPassword(text) {
                signUpView.passwordTextField.setupRightSideImage(imageViewName: "checkmark.circle.fill", passed: true)
                signUpView.isPasswordPassed = true
            } else {
                signUpView.passwordTextField.setupRightSideImage(imageViewName: "xmark.circle.fill", passed: false)
                signUpView.isPasswordPassed = false
            }
        }
    }
    
    
    // MARK: - 뒤로 돌아가기 : StartingPointViewController
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func signUpButtonTapped() {
        guard let email = signUpView.emailTextField.text else { return }
        guard let password = signUpView.passwordTextField.text else { return }
        print(email, password)
        // 프로필 입력 작업으로 넘어가게 하기
        let profileVC = FirstProfileGreetingViewController()
        profileVC.email = email
        profileVC.password = password
        profileVC.modalPresentationStyle = .fullScreen
        profileVC.modalTransitionStyle = .crossDissolve
        present(profileVC, animated: true)
    }
    
    @objc func termsLabelTapped() {
        showSafariView(url: Constant.Web.terms)
    }
    
    @objc func policyLabelTapped() {
        showSafariView(url: Constant.Web.policy)
    }
    
    func showSafariView(url: String) {
        let newsUrl = NSURL(string: url)
        let newsSafariView: SFSafariViewController = SFSafariViewController(url: newsUrl! as URL)
        self.present(newsSafariView, animated: true, completion: nil)
    }
}


