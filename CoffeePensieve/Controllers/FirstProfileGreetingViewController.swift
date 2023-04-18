//
//  FirstProfileViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/16.
//

import UIKit

class FirstProfileGreetingViewController: UIViewController {

    let greetingView = FirstProfileGreetingView()
    
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
        let firstVC = FirstProfileRoutineViewController()
        firstVC.modalPresentationStyle = .fullScreen
        present(firstVC, animated: true)
    }

}
