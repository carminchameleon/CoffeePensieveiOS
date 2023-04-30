//
//  AppViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/18.
//

import UIKit

class AppController {
    
    // 싱글톤 패턴
    static let shared = AppController()
    // 생성자 통해서 이벤트를 등록
    
    
    private var window: UIWindow!
    
    private var rootViewController: UIViewController? {
          didSet {
              // rootViewController가 바뀌면, window의 root를 바꿔준다.
              window.rootViewController = rootViewController
          }
      }
    
    func show(in window: UIWindow) {
           self.window = window
           window.backgroundColor = .systemBackground
           window.makeKeyAndVisible()
           
        checkLoginStatus()
    }

      private init() {
          registerAuthStateDidChangeEvent()
      }
      
      private func registerAuthStateDidChangeEvent() {
        
          NotificationCenter.default.addObserver(self, selector: #selector(checkLoginStatus), name: .authStatusDidChange, object: nil)
          }
    
    @objc private func checkLoginStatus() {
        
        let isSignIn = UserDefaults.standard.bool(forKey: "isSignIn") == true
        if isSignIn {
            // 로그인이 되어 있다면 메인 페이지로 이동
//            setHome()
        } else {
            // 안되어 있다면 로그인 관련 페이지로 이동
//            routeToLogin()
        }
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
