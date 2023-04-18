//
//  StartPointViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/09.
//

import UIKit

class StartPointViewController: UIViewController {
    
    private let startPointView = AuthStartPointView()

    override func loadView() {
        view = startPointView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    

    func addTargets() {
        startPointView.emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        startPointView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
  
    
    @objc func loginButtonTapped() {
    print("login button Tapped")
    let logInVC = SignInViewController()
        logInVC.modalPresentationStyle = .fullScreen
        present(logInVC, animated: true)
    }

    @objc func emailButtonTapped() {
        print("email button tapped")
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true)
    }
}
