//
//  ProfileViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/23.
//

import UIKit
import Firebase
import SafariServices

final class ProfileViewController: UIViewController {

    let authManager = AuthNetworkManager.shared
    
    let menuList = [
                    ProfileMenu(type:Menu.profile, title: "Account", icon: "person.crop.circle"),
                    ProfileMenu(type:Menu.preference, title: "Preference", icon: "slider.horizontal.3"),
                    ProfileMenu(type:Menu.support, title: "Help & Support", icon: "questionmark.circle"),
                    ProfileMenu(type:Menu.term, title: "Terms of Service", icon: "doc.plaintext"),
                    ProfileMenu(type:Menu.policy, title: "Privacy Policy", icon: "lock.shield"),
                    ProfileMenu(type:Menu.about, title: "About", icon: "sparkles"),
                    ProfileMenu(type:Menu.delete, title: "Delete Account", icon: "hand.raised.fingers.spread"),
                    ProfileMenu(type:Menu.logout, title: "Log out", icon: "door.sliding.right.hand.open"),
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
        navigationItem.title = "Setting"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
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
        
        func initTimePicker(time: String, picker: UIDatePicker) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            if let date = dateFormatter.date(from: time) {
                picker.date = date
            }
        }

    }

    func profileTapped() {
        let nickNameVC = NickNameViewController()
        self.navigationController?.pushViewController(nickNameVC, animated: true)
    }

    func preferenceTapped() {
        let preferenceVC = PreferenceViewController()
        self.navigationController?.pushViewController(preferenceVC, animated: true)
    }
    
    func deleteAccountTapped() {
        let deleteVC = AccountDeleteViewController()
        self.navigationController?.pushViewController(deleteVC, animated: true)
    }
    
    func helpSupportTapped() {
        showSafariView(url: Constant.Web.help)
    }

    func termOfServiceTapped() {
        showSafariView(url: Constant.Web.terms)
    }

    func privacyPolicyTapped() {
        showSafariView(url: Constant.Web.policy)
    }

    func aboutTapped() {
        showSafariView(url: Constant.Web.about)
    }
    
    func showSafariView(url: String) {
        let newsUrl = NSURL(string: url)
        let newsSafariView: SFSafariViewController = SFSafariViewController(url: newsUrl! as URL)
        self.present(newsSafariView, animated: true, completion: nil)
    }
    
    func logOutTapped(){
        authManager.signOut()
    }
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId.ProfileCell.rawValue, for: indexPath) as! ProfileTableViewCell
        let data = menuList[indexPath.row]
        cell.menuLabel.text = data.title
        cell.iconView.image = UIImage(systemName: data.icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = menuList[indexPath.row]
        switch selectedData.type {
        case .profile:
            self.profileTapped()
        case .preference:
            self.preferenceTapped()
        case .delete:
            self.deleteAccountTapped()
        case .support:
            self.helpSupportTapped()
        case .term:
            self.termOfServiceTapped()
        case .policy:
            self.privacyPolicyTapped()
        case .about:
            self.aboutTapped()
        case .logout:
            self.logOutTapped()
        }
    }
}
