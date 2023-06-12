//
//  PreferenceView.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/28.
//

import UIKit

class PreferenceView: UIView {

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .white
        tableView.allowsSelection = true
        tableView.separatorColor = .primaryColor500
        tableView.canCancelContentTouches = true
        return tableView
    }()
    
    let notificationLabel : UILabel = {
        let label = UILabel()
        label.text = "Get Reminders"
        label.font = FontStyle.callOut
        label.textAlignment = .left
        label.textColor = .primaryColor400
        return label
    }()

    let switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = true
        switchButton.onTintColor = .primaryColor700
        return switchButton
    }()
    
    let setButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Save Settings", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.primaryColor500, for: .normal)
        button.backgroundColor = .primaryColor25
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        backgroundColor = .white
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 400)
        ])

        
        addSubview(setButton)
        setButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -78),
            setButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            setButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            setButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        addSubview(notificationLabel)
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notificationLabel.topAnchor.constraint(equalTo: setButton.topAnchor, constant: -42),
            notificationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            notificationLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        addSubview(switchButton)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            switchButton.topAnchor.constraint(equalTo: setButton.topAnchor, constant: -42),
            switchButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            switchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])


    }
}
