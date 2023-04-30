//
//  FirstProfileViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/16.
//

import UIKit

class FirstProfileGreetingViewController: UIViewController {

    let greetingView = FirstProfileGreetingView()
    var email:String = ""
    var password: String = ""
    
    override func loadView() {
        view = greetingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
    }
    
    func addTargets(){
        greetingView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchDown)
    }
    
    
    @objc func nextButtonTapped() {
        let routineVC = FirstProfileRoutineViewController()
        routineVC.email = email
        routineVC.password = password
        routineVC.modalPresentationStyle = .fullScreen
        present(routineVC, animated: true)
    }

}
