//
//  OnboardingViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/08.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Coffee \n Pensieve"
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    
    var imageView: UIImageView = {
        let imageName = "Cloud 1"
        let onboardingImage = UIImage(named: imageName)
        let imageView = UIImageView(image: onboardingImage!)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.contentMode =  .scaleToFill
        return imageView
    }()
    
    var mainTitle : UILabel = {
        let label = UILabel()
        label.text = "Create an account to \n make your coffee tracker"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    
    var subTitle : UILabel = {
        let label = UILabel()
        label.text = "how many cups of coffee do you drink a day? \n What made you need a coffee? \n Keep your coffee moment."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [mainTitle, subTitle])
        st.spacing = 8
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        return st
    }()

    
    init(imageName: String, mainText: String, subText: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
        mainTitle.text = mainText
        subTitle.text = subText
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    private func makeUI() {
        view.backgroundColor = .primaryColor25
        view.addSubview(imageView)
        view.addSubview(stackView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),imageView.heightAnchor.constraint(equalToConstant: 300)]
        )
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 44),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
    

}
