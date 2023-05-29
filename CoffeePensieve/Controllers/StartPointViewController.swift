//
//  StartPointViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/09.
//

import UIKit
import Firebase
import GoogleSignIn
import AuthenticationServices

class StartPointViewController: UIViewController {
    
    private let startPointView = AuthStartPointView()

    var isFirst = true
    
    override func loadView() {
        view = startPointView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        if isFirst {
            let welcomeVC = WelcomeViewController()
            welcomeVC.modalPresentationStyle = .fullScreen
            present(welcomeVC, animated: false)
            isFirst.toggle()
        }
    }

    func addTargets() {
        startPointView.emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        startPointView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        startPointView.googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        startPointView.appleButton.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
    }
  
    
    @objc func loginButtonTapped() {
    let logInVC = SignInViewController()
        logInVC.modalPresentationStyle = .fullScreen
        present(logInVC, animated: true)
    }

    @objc func emailButtonTapped() {
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true)
    }
    
    @objc func googleButtonTapped() {
        // 파이어베이스에 대한 clientID 받기
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
//
//            if let error = error {
////                print("Google Sign In Error -", error.localizedDescription)
////                let alert = UIAlertController(title: "Sorry", message: error.localizedDescription, preferredStyle: .alert)
////                let tryAgain = UIAlertAction(title: "Okay", style: .default) { action in
////                    self.dismiss(animated: true)
////                }
////                alert.addAction(tryAgain)
////                self.present(alert, animated: true, completion: nil)
//            }

        // 유저, userToken 받기
          guard let user = result?.user, let idToken = user.idToken?.tokenString else {
              print("Google Sign In Token Error - couldn't make user token")
              return
          }

        // 구글 로그인 -> 유저 정보: credential (firebase에 로그인하려면 필요함)
          let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

        // firebase에 로그인
            Auth.auth().signIn(with: credential) {[weak self] result, error in
                guard let strongSelf = self else { return }
                if let error = error {
                    print("Firebase Google Sign In Error -", error.localizedDescription)
                    let alert = UIAlertController(title: "Sorry", message: error.localizedDescription, preferredStyle: .alert)
                    let tryAgain = UIAlertAction(title: "Okay", style: .default) { action in
                        strongSelf.dismiss(animated: true)
                    }
                    alert.addAction(tryAgain)
                    strongSelf.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @objc func appleButtonTapped() {
        
    }
    
}
