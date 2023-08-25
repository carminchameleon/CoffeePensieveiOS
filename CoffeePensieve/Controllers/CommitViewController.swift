//
//  CommitViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/18.
//

import UIKit
import Firebase

class CommitViewController: UIViewController {
    
    let dataManager = DataManager.shared
    let commitManager = CommitNetworkManager.shared
    
    let commitView = CommitMainView()
    var userName: String = ""
    var todayCount = 0
    var totalCount: Int! = 0
    var greeting = ""
    var cherringSentence = Common.getGreetingSentenceByTime()
    
    override func loadView() {
        view = commitView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        getGreeting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // navigation 세팅
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
       
        Task {
            await getTodaysCommit()
            await getTotalCommit()
        }
        getUserName()
    }
    
    func addTargets() {
        commitView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc func addButtonTapped() {
        let coffeeVC = CommitCoffeeViewController()
        navigationController?.pushViewController(coffeeVC, animated: true)
    }
    
    
    func getGreeting() {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let date = dateFormatter.string(from: nowDate)// 현재 시간의 Date를 format에 맞춰 string으로 반환
        let currentTime = Int(date)!
        
        switch currentTime {
        case 0...12 :
            greeting = "Good morning \n"
        case 12...17 :
            greeting = "Good afternoon \n"
        default:
            greeting = "Good evening \n"
        }
        commitView.greetingLabel.text = greeting
        commitView.cheeringLabel.text = cherringSentence
    }
    
    // MARK: - Get User Name From UserDefaults
    // 이미 저장되어 있는지 확인 하고, 만약 안되어있으면 그때 받아온다.
    // 저장되어있다면, 기존 것에서 가져오기 /  저장 안되어있으면 api에서 가져온다.
    func getUserName() {
        if Common.getUserDefaultsObject(forKey: .name) != nil {
            self.updateName()
        } else {
            // api에서 데이터 가져와서 UserDefault에 저장
            dataManager.getUserProfileFromAPI {[weak self] result in
                switch result {
                case .success:
                    self?.updateName()
                case .failure:
                    // DB에 없는 경우 - 소셜 로그인으로 가입해서 유저 프로필이 없는 경우
                    let profileVC = FirstProfileGreetingViewController()
                    profileVC.isSocial = true
                    self?.navigationController?.pushViewController(profileVC, animated: true)
                }
            }
        }
    }

    
    // MARK: - get today's coffee
    func getTodaysCommit() async {
        let result = await commitManager.fetchTodayCommitCounts()
        switch result {
        case .success(let count):
            todayCount = count
            self.updateImage()
        case .failure(let error):
            print(error.localizedDescription)
        }
    }

    // MARK: - get total coffee
    func getTotalCommit() async {
        let result = await commitManager.fetchTotalCommitCounts()
        switch result {
        case .success(let count):
            totalCount = count
            self.updateTotalCommitCount()
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func updateName(){
        guard let name = Common.getUserDefaultsObject(forKey: .name) as? String else { return }
        let greetingSentence = "\(greeting) \(name)"
        commitView.greetingLabel.text = greetingSentence
    }
    
    func updateImage() {
        var memoryNumber = 0
        switch todayCount {
        case 0:
            memoryNumber = 0
        case 1:
            memoryNumber = 1
        case 2:
            memoryNumber = 2
        case 3:
            memoryNumber = 3
        default:
            memoryNumber = 4
        }
        
        UIView.transition(with: commitView.imageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.commitView.imageView.image = UIImage(named: "Memory-\(memoryNumber)")
        }, completion: nil)
    }
        
    func updateTotalCommitCount() {
        let ordinalFormatter = NumberFormatter()
        ordinalFormatter.numberStyle = .ordinal
        ordinalFormatter.locale = Locale(identifier: "en")
        
        let count: Int = self.totalCount
        
        guard let formattedNumber = ordinalFormatter.string(from: NSNumber(value: count + 1)) else { return }
        let sentence = "Would you like to add your \(formattedNumber) memory?"
        commitView.suggestionLabel.text = sentence
    }
    

    
}
