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
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setDrinkLayout()
        setMoodLayout()
    }
    
    func setDrinkLayout() {
        let width = self.resultView.drinkContainer.frame.width
        guard let text = resultView.coffeeLabel.text else { return }
        let image: CGFloat = 40
        let spacing: CGFloat = 8
        let font = FontStyle.callOut
        let size = (text as NSString).size(withAttributes: [.font: font])
        let stackViewWidth = image + spacing + size.width
        let margin = (width - stackViewWidth) / 2
        resultView.drinkLabelStackView.leadingAnchor.constraint(equalTo: resultView.drinkContainer.leadingAnchor, constant: margin).isActive = true
 
    }
    
    func setMoodLayout() {
        let width = self.resultView.moodContainer.frame.width
        guard let text = resultView.moodLabel.text else { return }
        let image: CGFloat = 40
        let spacing: CGFloat = 8
        let font = FontStyle.callOut
        let size = (text as NSString).size(withAttributes: [.font: font])
        let stackViewWidth = image + spacing + size.width
        let margin = (width - stackViewWidth) / 2
        resultView.moodLabelStackView.widthAnchor.constraint(equalToConstant: stackViewWidth).isActive = true
        resultView.moodLabelStackView.leadingAnchor.constraint(equalTo: resultView.moodContainer.leadingAnchor, constant: margin).isActive = true
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
        resultView.dateLabel.text = dateString
    }
    
    
    func updateMemoData() {
        if memo.isEmpty {
            resultView.memoMenuTitle.isHidden = true
            resultView.memoView.isHidden = true
            resultView.memoMenuTitle.heightAnchor.constraint(equalToConstant: 0).isActive = true
            resultView.memoView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        } else {
            resultView.memoView.text = memo
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
            resultView.coffeeLabel.text = "\(tempMode) / \(drink.name)"
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
