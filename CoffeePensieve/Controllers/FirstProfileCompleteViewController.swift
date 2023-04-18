//
//  FirstProfileCompleteViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/17.
//

import UIKit

class FirstProfileCompleteViewController: UIViewController {

    let completeView = FirstProfileCompleteView()
    
    override func loadView() {
        view = completeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
