//
//  AccountDeleteViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/06/04.

import UIKit

class AccountDeleteViewController: UIViewController {

    let authManager = AuthNetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitle()
        setUI()
        deleteButton.addTarget(self, action: #selector(firstAskButtonClicked), for: .touchUpInside)
    }
    
    
    let mainLabel : UILabel = {
        let label = UILabel()
        label.text = "We're so sorry to see you go. \n\nDeleting your account is irreversible and means that you will no longer be able to access your coffee memories.\n\nWe welcome any feedback you may have about the app, so please don't hesitate to contact us. Thank you for downloading and using Coffee Pensieve. \n\nWe hope you have enjoyed your experience with Coffee Pensieve and wish you a delightful day ahead. \n\nBest regards,\nCoffee Pensieve"
        
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .primaryColor500
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Delete Account", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.primaryColor500, for: .normal)
        button.backgroundColor = .primaryColor25
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        return button
    }()
    
    @objc func firstAskButtonClicked() {
        let deleteAlert = UIAlertController(title: "Are you sure you want to delete your account?", message: "Deleting your account is irreversible and means that you will no longer be able to access your coffee memories", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete Account", style: .cancel) {action in
            self.deleteAccount()
        }
        let keepAction = UIAlertAction(title: "Keep Account", style: .default)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(keepAction)

        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    func deleteAccount() {
        // auth
        // db에서도 삭제
        authManager.deleteAccount { error in
            var errorMessage = ""
            switch error {
            case .dataError:
                errorMessage = "Failed to delete your account. Please try again later"
            case .databaseError:
                errorMessage = "Failed to delete your account from database. Please try again later"
            case .uidError:
                errorMessage = "Failed to delete your account. Couldn't find your id. Please try again later"
                
                let deleteAlert = UIAlertController(title: "Sorry", message: errorMessage, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .default)
                
                deleteAlert.addAction(okayAction)
                self.present(deleteAlert, animated: true, completion: nil)
            }
        }
    }
    
    func configureTitle() {
        navigationItem.title = "Delete Account"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .primaryColor500
        tabBarController?.tabBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .white
    }
    
    func setUI() {
        self.view.addSubview(mainLabel)
        self.view.addSubview(deleteButton)
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            mainLabel.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -88),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            deleteButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

}
