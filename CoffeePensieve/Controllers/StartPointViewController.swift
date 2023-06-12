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
import CryptoKit
import SafariServices

class StartPointViewController: UIViewController {
    
    var isFirst = true
    
    private let startPointView = AuthStartPointView()
    fileprivate var currentNonce: String?
        
    override func loadView() {
        view = startPointView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 처음 실행시 WelcomeViewController를 띄운다.
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
        
        // terms, policy 사파리 뷰 이동을 위한 코드 설정
        let tapGestureForTerms = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped))
        let tapGestureForPolicy = UITapGestureRecognizer(target: self, action: #selector(policyLabelTapped))
        startPointView.infoLabel.isUserInteractionEnabled = true
        startPointView.infoLabel.addGestureRecognizer(tapGestureForTerms)
        startPointView.policyLabel.isUserInteractionEnabled = true
        startPointView.policyLabel.addGestureRecognizer(tapGestureForPolicy)
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
            
            if let error = error {
                print("Google Sign In Error -", error.localizedDescription)
                let alert = UIAlertController(title: "Sorry", message: error.localizedDescription, preferredStyle: .alert)
                let tryAgain = UIAlertAction(title: "Okay", style: .default) { action in
                    self.dismiss(animated: true)
                }
                alert.addAction(tryAgain)
                self.present(alert, animated: true, completion: nil)
            }
            
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
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
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


extension StartPointViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          
            guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
          }

          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
          }
            print(idTokenString)
            
          // Initialize a Firebase credential, including the user's full name.
          let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                            rawNonce: nonce,
                                                            fullName: appleIDCredential.fullName)
          // Sign in with Firebase.
          Auth.auth().signIn(with: credential) {[weak self] (authResult, error) in
              guard let strongSelf = self else { return }

              if let error = error {
                print(error.localizedDescription)
                
                let alert = UIAlertController(title: "Sorry", message: error.localizedDescription, preferredStyle: .alert)
                let tryAgain = UIAlertAction(title: "Okay", style: .default) { action in
                    strongSelf.dismiss(animated: true)
                }
                alert.addAction(tryAgain)
                strongSelf.present(alert, animated: true, completion: nil)
                  return
                }
            // User is signed in to Firebase with Apple.
            // ...
              print("Apple Sign in 완료 되었음")
          }
        }
      }

    
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        guard let appleCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
//            return
//        }
//
//        guard let nonce = currentNonce else {
//            NSLog("Invalid state: A login callback was received, but no login request was sent.")
//            return
//        }
//        guard let appleIDToken = appleCredential.identityToken else {
//            NSLog("Unable to fetch identity token")
//
//            return
//        }
//        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//            NSLog("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//
//            return
//        }
//
//        // Initialize a Firebase credential.
//        // Sign in with Firebase.
//    }
}

extension StartPointViewController {
    // 로그인 요청시 임의의 문자열 nonce를 생성
    // 앱의 인증에 대한 응답으로 id토큰이 부여되었는지 확인 ( 연속해서 보내는거에 대한 확인 1--> 1 로만 받을 수 있도록
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    // 해당 된 값을 해싱하는 함수.
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}
