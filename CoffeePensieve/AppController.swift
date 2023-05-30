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
        window?.backgroundColor = .white
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
        tabBarVC.tabBar.layer.borderWidth = 0.50
        tabBarVC.tabBar.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        tabBarVC.tabBar.clipsToBounds = true
        

        // 첫번째 화면은 네비게이션컨트롤러로 만들기 (기본루트뷰 설정)
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



