//
//  OnboardingViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/08.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    private let onboardingView = OnboardingView()
    
    override func loadView() {
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(imageName: String, mainText: String, subText: String) {
        super.init(nibName: nil, bundle: nil)
        onboardingView.imageView.image = UIImage(named: imageName)
        onboardingView.mainTitle.text = mainText
        onboardingView.subTitle.text = subText
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
