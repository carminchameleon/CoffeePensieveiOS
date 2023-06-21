//
//  AppController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/28.
//

import UIKit
import Firebase

final class AppController {

    static let shared = AppController()
    
    private init() {
        registerAuthStateDidChangeEvent()
    }
    
    private var window: UIWindow?
    
    private var rootViewController: UIViewController? {
        didSet {
            window?.rootViewController = rootViewController
        }
    }
    
    func show(in window: UIWindow?) {
        self.window = window
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
        checkLoginStatus()
    }
    
    private func registerAuthStateDidChangeEvent() {
        // .AuthStateDidChange : Firebase에서 연동되는 이벤트
        NotificationCenter.default.addObserver(self, selector: #selector(checkLoginStatus), name: .AuthStateDidChange, object: nil)
    }
    
    @objc private func checkLoginStatus() {
        // 기존 유저 정보가 저장되어 있는 경우
        if let _ = Common.getUserDefaultsObject(forKey: .userId) {
            moveMain()
        } else {
            if let user = Auth.auth().currentUser {
                Common.setUserDefaults(user.uid, forKey: .userId)
                moveMain()
            } else {
                moveWelcome()
            }
        }
    }

    let tabBarVC: UITabBarController = {
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.layer.borderWidth = 0.50
        tabBarVC.tabBar.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        tabBarVC.tabBar.tintColor = .primaryColor500
        tabBarVC.tabBar.clipsToBounds = true
        return tabBarVC
    }()

    

    private func moveMain() {
        
        let commitVC = UINavigationController(rootViewController: CommitViewController())
        let trackerVC = UINavigationController(rootViewController: TrackerViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        // 탭바 이름들 설정
        commitVC.title = "Coffee"
        trackerVC.title = "Tracker"
        profileVC.title = "Setting"

        // 탭바로 사용하기 위한 뷰 컨트롤러들 설정
        tabBarVC.setViewControllers([commitVC, trackerVC, profileVC], animated: true)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .white

        // 탭바 이미지 설정 (이미지는 애플이 제공하는 것으로 사용)
        guard let items = tabBarVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "cup.and.saucer.fill")
        items[1].image = UIImage(systemName: "chart.bar.fill")
        items[2].image = UIImage(systemName: "gear.circle")
                
        // 기본루트뷰를 탭바컨트롤러로 설정⭐️⭐️⭐️
        tabBarVC.selectedIndex = 0
        rootViewController = tabBarVC
    }

    private func moveWelcome(){
        let startingVC = StartPointViewController()
        rootViewController = UINavigationController(rootViewController: startingVC)
    }
    
}
