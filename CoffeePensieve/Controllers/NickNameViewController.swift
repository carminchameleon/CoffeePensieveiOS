//
//  NickNameViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/29.
//

import UIKit

class NickNameViewController: UIViewController {
    
    let dataManager = DataManager.shared
    let authManager = AuthNetworkManager.shared
    
    var name: String = ""
    var currentName: String = ""
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Name"
        label.font = FontStyle.callOut
        label.textColor = .primaryColor500
        label.textAlignment = .left
        return label
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearButtonMode = .always
        tf.textAlignment = .left
        tf.attributedPlaceholder = NSAttributedString(string: "A.k.a Dumbledore", attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayColor400])
        return tf
    }()
    
    let limitLabel: UILabel = {
        let label = UILabel()
        label.font = FontStyle.callOut
        label.textColor = .grayColor300
        label.textAlignment = .right
        return label
    }()
    
    lazy var line: UIView = {
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
        lineView.backgroundColor = .black
        return lineView
    }()    
    
    @objc func okButtonTapped() {
        Task {[weak self] in
            guard let self = self else { return }
            do {
                try await self.authManager.updateUserName(name: name)
                let newProfile = try await self.authManager.getUpdatedUserData()
                dataManager.saveProfiletoUserDefaults(userProfile: newProfile)
                self.navigationController?.popViewController(animated: true)
            } catch {
                AlertManager.showTextAlert(on: self, title: "Sorry", message: "Fail to update your name.\n Please try again later.") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        self.nameTextField.delegate = self
        addTargets()
        setNavigationTitle()
        setUI()
    }
    
    func setNavigationTitle() {
        navigationItem.title = "Profile"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        tabBarController?.tabBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(okButtonTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func getUserData() {
        guard let defaultName = Common.getUserDefaultsObject(forKey: .name) as? String else { return }
        name = defaultName
        currentName = defaultName

        DispatchQueue.main.async {
            self.nameTextField.text = defaultName
            self.limitLabel.text = "\(defaultName.count) / 20"
        }
    }
    
    func addTargets() {
        nameTextField.addTarget(self, action: #selector(nameValueChanged(_:)), for: .editingChanged)
    }
    
    @objc func nameValueChanged(_ textField: UITextField) {
        if textField.text?.first == " " {
               textField.text = ""
               return
       }
        guard let userName = textField.text else { return }
        self.name = userName
        let count = userName.count
        navigationItem.rightBarButtonItem?.isEnabled = count > 0 && currentName != name

        DispatchQueue.main.async {
            self.limitLabel.text = "\(count) / 20"
        }
    }
    
    func setUI() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        view.addSubview(limitLabel)
        limitLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            limitLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            limitLabel.widthAnchor.constraint(equalToConstant: 60),
            limitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            limitLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: limitLabel.leadingAnchor, constant: -4),
            nameTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        view.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 2),
            line.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            line.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
}

extension NickNameViewController : UITextFieldDelegate {
    // 엔터 눌렀을 대 넘어가는 것
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
}
