//
//  CommitLoadingViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/06.
//

import UIKit

class CommitLoadingViewController: UIViewController {

    var pensieveViewTopContstaint: NSLayoutConstraint!
    
    let commitManager = CommitNetworkManager.shared
    
    var selectedDrink: Int?
    var selectedMood: Int?
    var selectedTags: [Int] = []
    
    var tags: [Int]?
    var memo: String = ""
    
    var pensieveView = PensieveView()
    
    var cheeringLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .grayColor500
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = Common.getGreetingSentenceByTime()
        return label
    }()
    
    var waterImage: UIImageView = {
        let imageName = "water1"
        let loadingImage = UIImage(named: imageName)
        let imageView = UIImageView(image: loadingImage!)
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.contentMode =  .scaleToFill
        return imageView
    }()
    
    var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Your memory is being \n put into your pensieve..."
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.opacity = 0
        return label
    }()


    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        print("view will appear")
        updateImage()

       
        
        
    }
    
    override func viewDidLoad() {
        print("view did load")
        super.viewDidLoad()
        setUI()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear")
        let position = pensieveView.layer.position.y
        let labelPosition = loadingLabel.layer.position.y
        
        let labelAnimation = CAKeyframeAnimation(keyPath: "position.y")
        labelAnimation.values = [labelPosition, labelPosition - 15]
        labelAnimation.keyTimes = [0, 1]
        labelAnimation.duration = 3
        

        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position.y")
        positionAnimation.values = [position, position - 15]
        positionAnimation.keyTimes = [0, 1]
        positionAnimation.duration = 3
        
        pensieveView.layer.add(positionAnimation, forKey: "movePensieve")
        waterImage.layer.add(positionAnimation, forKey: "movePensieve")
        loadingLabel.layer.add(labelAnimation, forKey: "moveLabel")
        updateAnimation()
        pensieveViewTopContstaint.constant = -15
        uploadData()

    }
    
    
    func updateImage() {
        let todayCount = commitManager.todayCommitCount % 4
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
        print("todaycount", todayCount)
        
        if memoryNumber == 0 {
            waterImage.alpha = 0
        } else {
            waterImage.image = UIImage(named: "water\(memoryNumber)")
        }
    }
    
    
    @objc func updateAnimation() {
        // 1. 투명도를 1에서 0으로 1초간 바꾼다. (fade out)
        UIView.animate(withDuration: 1.5) {
            self.loadingLabel.alpha = 1
            self.waterImage.alpha = 0
        } completion: { (finished) in
            // fade out이 된 상태 (아무것도 안보이는 상태) 에서,
            // 이미지를 교체한다. (아무것도 안보이기 때문에 이미지 튕김이 없음)
            self.waterImage.image = UIImage(named: "water3")
            // 그 다음, Opacity를 다시 0에서 1로 1초간 바뀌게 하면
            // 바뀐 이미지로 투명도가 조절되어 보인다.
            UIView.animate(withDuration: 1.5) {
                self.waterImage.alpha = 1
            }
        }
    }
    
    // commitData를 업로드
    func uploadData() {
        commitManager.uploadTodayDrink(drinkId: selectedDrink!, moodId: selectedMood!, tagIds: selectedTags, memo: memo) {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let time):
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    strongSelf.moveToResultView(time)
                }

                // 새로운 커밋 생성 여부
                NotificationCenter.default.post(name: Notification.Name(rawValue: "NewCommitMade"), object: true)
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

    
    func moveToResultView(_ time: Date) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            let resultVC = CommitResultViewController()
            resultVC.data = CommitResultDetail(drinkId: self.selectedDrink!, moodId: self.selectedMood!, tagIds: self.selectedTags, memo: self.memo, createdAt: time)
            self.navigationController?.pushViewController(resultVC, animated: true)            
        }
    }
//    
//    func fadeInAnimation() {
//        UIView.animate(withDuration: 1.0) {
//            self.imageView.alpha = 1
//            self.loadingLabel.alpha = 1
//        }
//    }
//    
    
    
    func setUI() {
        view.backgroundColor = .white
        view.addSubview(pensieveView)
        pensieveView.translatesAutoresizingMaskIntoConstraints = false
        
        
        pensieveViewTopContstaint = pensieveView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        
        
        NSLayoutConstraint.activate([
            pensieveViewTopContstaint,
//            pensieveView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pensieveView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pensieveView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            pensieveView.heightAnchor.constraint(equalTo: pensieveView.widthAnchor, multiplier: 1)
        ])
        
        view.addSubview(waterImage)
        waterImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            waterImage.leadingAnchor.constraint(equalTo: pensieveView.leadingAnchor, constant: 30),
            waterImage.trailingAnchor.constraint(equalTo: pensieveView.trailingAnchor, constant: -30),
            waterImage.topAnchor.constraint(equalTo: pensieveView.topAnchor, constant: 30),
            waterImage.bottomAnchor.constraint(equalTo: pensieveView.bottomAnchor, constant: -30),
        ])
        
        view.addSubview(loadingLabel)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingLabel.topAnchor.constraint(equalTo: pensieveView.bottomAnchor, constant: 36),
            loadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            loadingLabel.heightAnchor.constraint(equalToConstant: ContentHeight.buttonHeight)
        ])
    }
//
//    
//    func setUI() {
//        self.imageView.alpha = 0
//        self.loadingLabel.alpha = 0
//        navigationItem.setHidesBackButton(true, animated: true)
//        view.backgroundColor = .white
//        
//        view.addSubview(imageView)
//        view.addSubview(loadingLabel)
//        view.addSubview(cheeringLabel)
//       
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
//        ])
//        
//        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            loadingLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -60),
//            loadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
//            loadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
//            loadingLabel.heightAnchor.constraint(equalToConstant: 60)
//        ])
//        
//        cheeringLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            cheeringLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
//            cheeringLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
//            cheeringLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
//            cheeringLabel.heightAnchor.constraint(equalToConstant: 60)
//        ])
//    }

}
