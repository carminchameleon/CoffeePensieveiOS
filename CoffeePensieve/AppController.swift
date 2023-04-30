//
//  AppController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/28.
//

import UIKit
import Firebase

class AppController {

    // 테스트용
    let isLoggedIn = true
    
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
        window?.backgroundColor = .systemBlue
        window?.makeKeyAndVisible()
        
        checkLoginStatus()
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkLoginStatus), name: .AuthStateDidChange, object: nil)
    }
    
    @objc private func checkLoginStatus() {
        
    
        if let user = Auth.auth().currentUser {
            Common.setUserDefaults(user.uid, forKey: .userId)
            moveMain()
        } else {
            moveWelcome()
        }
    }
    
    private func moveMain() {
        // 탭바컨트롤러의 생성
        let tabBarVC = UITabBarController()
        // 첫번째 화면은 네비게이션컨트롤러로 만들기 (기본루트뷰 설정)
        let commitVC = UINavigationController(rootViewController: CommitViewController())
        let trackerVC = TrackerViewController()
        let profileVC = ProfileViewController()

        // 탭바 이름들 설정
        commitVC.title = "Coffee"
        trackerVC.title = "Activity"
        profileVC.title = "Profile"

        // 탭바로 사용하기 위한 뷰 컨트롤러들 설정
        tabBarVC.setViewControllers([commitVC, trackerVC, profileVC], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .white

        // 탭바 이미지 설정 (이미지는 애플이 제공하는 것으로 사용)
        guard let items = tabBarVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "cup.and.saucer.fill")
        items[1].image = UIImage(systemName: "chart.bar.doc.horizontal")
        items[2].image = UIImage(systemName: "person.crop.circle.fill")

        // 기본루트뷰를 탭바컨트롤러로 설정⭐️⭐️⭐️
        rootViewController = tabBarVC
    }
    
    private func moveWelcome(){
        let startingVC = StartPointViewController()
        rootViewController = UINavigationController(rootViewController: startingVC)
    }
}

extension Notification.Name {
    static let authSatateDidChange = NSNotification.Name("authStateDidChange")
}
