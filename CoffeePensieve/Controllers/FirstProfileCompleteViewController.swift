//
//  FirstProfileCompleteViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/17.
//

import UIKit

final class FirstProfileCompleteViewController: UIViewController {

    let completeView = FirstProfileCompleteView()
    
    override func loadView() {
        view = completeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
    }
    
    private func addTarget() {
        completeView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc func nextButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
