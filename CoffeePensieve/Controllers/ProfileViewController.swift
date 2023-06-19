//
//  ProfileViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/23.
//

import UIKit
import Firebase
import SafariServices

class ProfileViewController: UIViewController {

    let dataManager = DataManager.shared
    let authManager = AuthNetworkManager.shared
    
    let menuList = [
                    ProfileMenu(type:Menu.profile, title: "Account", icon: "person.crop.circle"),
                    ProfileMenu(type:Menu.preference, title: "Preference", icon: "gear.circle"),
                    ProfileMenu(type:Menu.support, title: "Help & Support", icon: "questionmark.circle"),
                    ProfileMenu(type:Menu.term, title: "Terms of Service", icon: "doc.plaintext"),
                    ProfileMenu(type:Menu.policy, title: "Privacy Policy", icon: "lock.shield"),
                    ProfileMenu(type:Menu.about, title: "About", icon: "face.smiling"),
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
        getRecentUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func getRecentUserData(){
        if Common.getUserDefaultsObject(forKey: .name) == nil {
            dataManager.getUserProfileFromAPI {[weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success:
                    return
                case .failure:
                    let failAlert = UIAlertController(title: "Sorry", message: "Fail to get your profile.\n Please try again later", preferredStyle: .alert)
                   let okayAction = UIAlertAction(title: "Okay", style: .default)
                   failAlert.addAction(okayAction)
                   strongSelf.present(failAlert, animated: true, completion: nil)
                }
            }

        }
        
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
        let accountVC = AccountSettingViewController()
        self.navigationController?.pushViewController(accountVC, animated: true)
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
