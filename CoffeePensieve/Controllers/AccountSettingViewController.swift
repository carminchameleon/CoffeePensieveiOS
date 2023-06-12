//
//  AccountSettingViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/06/04.
//

import UIKit

class AccountSettingViewController: UIViewController {
    
    let menuList = [
                    ProfileMenu(type:Menu.profile, title: "Profile", icon: "face.smiling"),
    ]
    
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.allowsSelection = true
        tableView.separatorColor = .primaryColor500
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTitle()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTitle() {
        navigationItem.title = "Account"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .primaryColor500
        tabBarController?.tabBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func configureTableView() {
        setTableViewConstraint()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: CellId.ProfileCell.rawValue)
        tableView.rowHeight = 50
    }
    
    
    func setTableViewConstraint() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension AccountSettingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId.ProfileCell.rawValue, for: indexPath) as! ProfileTableViewCell
        let data = menuList[indexPath.row]
        cell.menuLabel.text = data.title
        cell.iconView.image = UIImage(systemName: data.icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let nickNameVC = NickNameViewController()
            self.navigationController?.pushViewController(nickNameVC, animated: true)
        }
        
    }
}
