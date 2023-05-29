//
//  CommitLoadingViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/06.
//

import UIKit

class CommitLoadingViewController: UIViewController {

    let dataManager = DataManager.shared
    
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
        uploadData()
        fadeInAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func uploadData() {

        // 값이 없다면 빈값으로 가는게 아니라 기본 값으로
        dataManager.uploadDrinkCommit(drinkId: selectedDrink!, moodId: selectedMood!, tagIds: selectedTags, memo: memo) {[weak self] result in
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
                
                let failAlert = UIAlertController(title: "Please try again", message: errorMessage, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .default) {action in
                    strongSelf.navigationController?.popToRootViewController(animated: true)
                }
                failAlert.addAction(okayAction)
                strongSelf.present(failAlert, animated: true, completion: nil)
            }
        }
    }

    
    func moveToResultView(_ time: Date) {
    
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
            let resultVC = CommitResultViewController()
            resultVC.drinkId = self.selectedDrink!
            resultVC.tagIds = self.selectedTags
            resultVC.memo = self.memo
            resultVC.moodId = self.selectedMood!
            resultVC.createdAt = time
            self.navigationController?.pushViewController(resultVC, animated: true)            
        }
        
    }
    
    func fadeInAnimation() {
        UIView.animate(withDuration: 2.0) {
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
       
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 400),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -60),
            loadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            loadingLabel.heightAnchor.constraint(equalToConstant: 60)

        ])
    }

}

