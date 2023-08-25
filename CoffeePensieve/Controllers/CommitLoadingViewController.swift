//
//  CommitLoadingViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/06.
//

import UIKit

class CommitLoadingViewController: UIViewController {

    let dataManager = DataManager.shared
    let commitManager = CommitNetworkManager.shared
    
    var selectedDrink: Int?
    var selectedMood: Int?
    var selectedTags: [Int] = []
    
    var tags: [Int]?
    var memo: String = ""
    
    var imageView: UIImageView = {
        let imageName = "Memory-2"
        let loadingImage = UIImage(named: imageName)
        let imageView = UIImageView(image: loadingImage!)
        imageView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        imageView.contentMode =  .scaleToFill
        return imageView
    }()
    
    var cheeringLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .grayColor500
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = Common.getGreetingSentenceByTime()
        return label
    }()
    
    var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Your memory is being \n put into your pensieve..."
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateImage()
        uploadData()
        fadeInAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // commitData를 업로드
    func uploadData() {
        commitManager.uploadTodayDrink(drinkId: selectedDrink!, moodId: selectedMood!, tagIds: selectedTags, memo: memo) {[weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let time):
                strongSelf.moveToResultView(time)
            
            case .failure(let error):
                
                var errorMessage = "Failed to upload data. If the problem repeats, please contact us."
                switch error {
                case .uidError:
                    errorMessage = "Fail to upload data, Please log out and log in again"
                case .databaseError:
                    errorMessage = "Failed to link DB. If the problem repeats, please contact us."
                case .dataError:
                    break
                }
                
                AlertManager.showTextAlert(on: strongSelf, title: "Sorry", message: errorMessage) {
                    strongSelf.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }

    func updateImage() {
        let todayCount = commitManager.todayCommitCount
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
        
        UIView.transition( with: self.imageView, duration: 1, options: .transitionCrossDissolve, animations: {
            self.imageView.image = UIImage(named: "Memory-\(memoryNumber)")
        }, completion: nil)
        
    }
    
    func moveToResultView(_ time: Date) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            let resultVC = CommitResultViewController()
//            resultVC.drinkId = self.selectedDrink!
//            resultVC.tagIds = self.selectedTags
//            resultVC.memo = self.memo
//            resultVC.moodId = self.selectedMood!
//            resultVC.createdAt = time
            resultVC.data = CommitResultDetail(drinkId: self.selectedDrink!, moodId: self.selectedMood!, tagIds: self.selectedTags, memo: self.memo, createdAt: time)
            self.navigationController?.pushViewController(resultVC, animated: true)            
        }
    }
    
    func fadeInAnimation() {
        UIView.animate(withDuration: 1.0) {
            self.imageView.alpha = 1
            self.loadingLabel.alpha = 1
        }
    }
    
    
    func setUI() {
        self.imageView.alpha = 0
        self.loadingLabel.alpha = 0
        navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(loadingLabel)
        view.addSubview(cheeringLabel)
       
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
        ])
        
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -60),
            loadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            loadingLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        cheeringLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cheeringLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            cheeringLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            cheeringLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            cheeringLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

}

