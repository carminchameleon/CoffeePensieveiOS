//
//  LogViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/12.
//

import UIKit

class LogViewController: UIViewController {
    
    private let loginView = LogInView()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        // Do any additional setup after loading the view.
    }
    
    func addTargets() {
        loginView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        loginView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        loginView.passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        loginView.forgotButton.addTarget(self, action: #selector(forgotButtonTapped), for: .touchUpInside)
        loginView.logInButton.addTarget(LogInViewController.self, action: #selector(logInButtonTapped), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)

    }
    
    
    // MARK: - 뒤로 돌아가기
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - 로그인 입력 필드 관련 로직 추가 필요
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        print("hello")
    }

    // MARK: - 비밀번호 까먹었음 버튼
    // 1. 이메일 필드가 아예 비워져 있는 경우 -> 이메일 채우고 클릭해줘
    // 2. 이메일 입력했지만 형식이 맞지 않는 경우 -> 이메일 형식을 확인 해줘
    // 3. 이메일 형식 맞을 경우 -> 서버 요청
    // 3-1. 존재하는 회원이 아니야
    // 3-2. 이메일 보낸 것 성공했어.
    // 다른곳 클릭하면 안보여주기
    // 키보드 입력되는 상태면 안보여주기 추가!
    @objc private func forgotButtonTapped() {
        
        let text = loginView.emailTextField.text ?? ""
        
        if text == "" {
            loginView.forgotPasswordInfoTooltip.isHidden = false
            return
        }
        
        if !isValidEmail(text) {
            loginView.forgotPasswordInfoTooltip.isHidden = false
            return
        }
        
        loginView.forgotPasswordSuccessTooltip.isHidden = false
        loginView.emailTextField.text = ""
    }
    
    
    // MARK: - TODO : 다음 작업
    @objc private func logInButtonTapped() {
        // TODO 기존에 있는 회원인지 아닌지 확인 필요
        // 다음 단계로 넘어가게 할 것인지 아닌지 체크
    }
    
    // MARK: - 회원가입 뷰로 이동
    @objc private func signUpButtonTapped() {
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        loginView.forgotPasswordInfoTooltip.isHidden = true
    }

}
