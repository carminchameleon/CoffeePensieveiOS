//
//  CommitViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/18.
//

import UIKit
import Firebase

class CommitViewController: UIViewController {
    
    let networkManager = AuthNetworkManager.shared    
    var isLoggedIn = false

    lazy var label: UILabel = {
        var label = UILabel()
        label.font = FontStyle.largeTitle
        label.text = "Large Title"
        return label
    }()
    // MARK: - 로그아웃 버튼 (임시 구현
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Large Title", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = FontStyle.largeTitle
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    func makeUI() {
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            logoutButton.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc func logoutButtonTapped() {
        let firebaseAuth = Auth.auth()
        do {
           try firebaseAuth.signOut()
        } catch let signOutError as NSError {
           print("Error signing out: %@", signOutError)
        }
    }
}
