//
//  FirstProfileViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/16.
//

import UIKit

final class FirstProfileGreetingViewController: UIViewController {

    let greetingView = FirstProfileGreetingView()
    var email:String = ""
    var password: String = ""
    var isSocial = false
    
    override func loadView() {
        view = greetingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        tabBarController?.tabBar.isHidden = true
    }
    
    private func addTargets(){
        greetingView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchDown)
    }
    
    @objc private func nextButtonTapped() {
        let routineVC = FirstProfileRoutineViewController()
        routineVC.email = email
        routineVC.password = password
        routineVC.isSocial = isSocial
        routineVC.modalPresentationStyle = .fullScreen
        
        if isSocial {
            navigationController?.pushViewController(routineVC, animated: true)
        } else {
            present(routineVC, animated: true)
        }
    }

}
