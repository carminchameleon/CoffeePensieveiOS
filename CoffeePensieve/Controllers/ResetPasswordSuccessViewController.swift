//
//  ResetPasswordSuccessViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/15.
//

import UIKit

class ResetPasswordSuccessViewController: UIViewController {

    let successView = ResetPasswordSuccessView()
    
    override func loadView() {
        view = successView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        addTargets()
    }
    
    func addTargets() {
        successView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchDown)
    }

    @objc func loginButtonTapped() {
        let signInVC = SignInViewController()
        signInVC.modalPresentationStyle = .fullScreen
        present(signInVC, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
