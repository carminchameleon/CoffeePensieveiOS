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
    let networkManager = AuthNetworkManager.shared
    
    var userData: UserProfile?
    let commitView = CommitMainView()
    var count: Int?
    var todayCount = 0
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
        fetchCommitData()
        fetchUserData()
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func addTargets() {
        commitView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
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

    
    func fetchUserData() {
        // 이미 저장되어 있는지 확인 하고, 만약 안되어있으면 그때 받아온다.
        // 저장되어있다면, 기존 것에서 가져오기
        // 저장 안되어있으면 api에서 가져오기
        // 필요한 데이터 -> name만
        if Common.getUserDefaultsObject(forKey: .name) != nil {
            dataManager.setProfileFromUserDefault()
            self.updateName()
        } else {
            // api에서 데이터 가져와서 UserDefault에 저장
            dataManager.getUserProfileFromAPI {[weak self] result in
                guard let weakSelf = self else { return }
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        weakSelf.updateName()
                    }
                case .failure:
                    let profileVC = FirstProfileGreetingViewController()
                    profileVC.isSocial = true
                    weakSelf.navigationController?.pushViewController(profileVC, animated: true)

                }
            }
        }
        
        
    }
    

    
    func fetchCommitData() {
        dataManager.getCommitCountFromAPI {[weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let number):
                weakSelf.count = number
                DispatchQueue.main.async {
                    weakSelf.updateCommitCount()
                }
            case .failure(let error):

                var errorMessage = "Failed to get your commits. Please try again later"
                switch error {
                case .uidError:
                    errorMessage = "Failed to get your information. Please sign in again."
                case .databaseError:
                    errorMessage = "Failed to link your DB. If the problem repeats, please contact us."
                case .dataError:
                    break
                }

                switch error {
                case .uidError:
                    let failAlert = UIAlertController(title: "Sorry", message: errorMessage, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Okay", style: .default) {action in
                        weakSelf.networkManager.signOut()
                    }
                    failAlert.addAction(okayAction)
                    weakSelf.present(failAlert, animated: true, completion: nil)
                default:
                    let failAlert = UIAlertController(title: "Sorry", message: errorMessage, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Okay", style: .default)
                    failAlert.addAction(okayAction)
                    weakSelf.present(failAlert, animated: true, completion: nil)
                }

            }
        }
        
        dataManager.fetchTodayCommits {[weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success:
                weakSelf.todayCount = weakSelf.dataManager.getNumberOfTodayCommit()
                DispatchQueue.main.async {
                    weakSelf.updateImage()
                }
            case .failure:
                break
            }
        }
    }
    func updateName(){
        guard let userProfile = dataManager.getUserData() else { return }
        let name = userProfile.name
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
    
    func updateCommitCount() {
        let ordinalFormatter = NumberFormatter()
        ordinalFormatter.numberStyle = .ordinal
        ordinalFormatter.locale = Locale(identifier: "en")
        guard let count = self.count else { return }
        guard let formattedNumber = ordinalFormatter.string(from: NSNumber(value: count + 1)) else { return }
    
        let sentence = "Would you like to add your \(formattedNumber) memory?"
        commitView.suggestionLabel.text = sentence
    }
    
    @objc func addButtonTapped() {
        let coffeeVC = CommitCoffeeViewController()
        navigationController?.pushViewController(coffeeVC, animated: true)
    }
    
    
}
