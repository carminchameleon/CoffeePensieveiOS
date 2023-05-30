//
//  CommitResultViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/07.
//

import UIKit

class CommitResultViewController: UIViewController {
    
    let resultView = CommitResultView()
    let dataManager = DataManager.shared
    
    var drinkId: Int?
    var moodId: Int?
    var tagIds: [Int] = []
    var memo: String = ""
    var createdAt: Date = Date()
    
    override func loadView() {
        view = resultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
   
    override func viewWillLayoutSubviews() {
        resultView.setGradient3Color(color1: .blueGradient100, color2: .blueGradient200, color3: .blueGradient300)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func setUI() {
        resultView.backgroundColor = .white
        navigationItem.title = "Summary"
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeTapped))
       
        updateInfoData()
        updateTimeData()
        updateMemoData()
        updateDrinkData()
        updateTagData()
        updateMoodData()
    }
    
    func updateTimeData() {
        // time
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "En") // 사용자 지정 로케일 설정 (한국어)
        dateFormatter.dateFormat = "EEEE, MMMM d 'at' h:mm a"
        let dateString = dateFormatter.string(from: createdAt)
        resultView.createdAtLabel.text = dateString
    }
    
    func updateMemoData() {
        let width = resultView.frame.width - 48
        
        if memo.isEmpty {
            resultView.detailTitle.isHidden = true
            return
        }

        let font =  UIFont.italicSystemFont(ofSize: 17)
        let height =  Common.heightForView(text: memo, font: font, width: width)
        if height > 500 {
            resultView.addSubview(resultView.memoView)
            resultView.memoView.translatesAutoresizingMaskIntoConstraints = false
            resultView.memoView.text = memo
            NSLayoutConstraint.activate([
                resultView.memoView.topAnchor.constraint(equalTo: resultView.detailTitle.bottomAnchor, constant: 12),
                resultView.memoView.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 24),
                resultView.memoView.trailingAnchor.constraint(equalTo: resultView.trailingAnchor, constant: -24),
                resultView.memoView.bottomAnchor.constraint(equalTo: resultView.safeAreaLayoutGuide.bottomAnchor, constant: -12),
        ])
        } else {
            resultView.detailView.text = memo
            resultView.addSubview(resultView.detailView)
            resultView.detailView.topAnchor.constraint(equalTo: resultView.detailTitle.bottomAnchor, constant: 12).isActive = true

        }
    }

    func updateDrinkData() {
        // drink
        let drinkList = dataManager.getDrinkListFromAPI()
        guard let selectedDrinkId = drinkId else { return }
        let selectedDrink = drinkList.filter { $0.drinkId == selectedDrinkId }
        if !selectedDrink.isEmpty {
            let drink = selectedDrink[0]
            resultView.coffeeImage.image = UIImage(named: drink.image)
            let tempMode = drink.isIced ? "🧊ICED" : "🔥HOT"
            resultView.drinkLabel.text = "\(tempMode) / \(drink.name)"
        }
    }
    
    func updateMoodData() {
        // mood
        let moodList = dataManager.getMoodListFromAPI()
        let mood = moodList.filter { $0.moodId == moodId }[0]
        resultView.moodLabel.text = mood.name
        resultView.moodImage.text = mood.image
    }
    
    func updateTagData() {
        // tags
        var tagText = ""
        let allTagList = dataManager.getTagListFromAPI()
        tagIds.forEach { tagId in
            let findedTag = allTagList.filter { $0.tagId == tagId}
            if !findedTag.isEmpty {
                let tag = findedTag[0].name
                tagText.append("#\(tag) ")
            }
        }
        resultView.tags.text = tagText
    }

    func updateInfoData() {
        guard let userProfile = dataManager.getUserData() else { return }
        let name = userProfile.name
        
        let ordinalFormatter = NumberFormatter()
        ordinalFormatter.numberStyle = .ordinal
        ordinalFormatter.locale = Locale(identifier: "en")
        let count = dataManager.getCommitCount()
        guard let formattedNumber = ordinalFormatter.string(from: NSNumber(value: count + 1)) else { return }
        resultView.userInfoLabel.text = "\(name)'s \(formattedNumber) Memory"
    }
    
    @objc func closeTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
