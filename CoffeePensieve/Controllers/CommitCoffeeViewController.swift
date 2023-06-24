//
//  CommitCoffeeViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/02.
//

import UIKit
class CommitCoffeeViewController: UIViewController {

    let dataManager = DataManager.shared
    
    var hotDrinks: [Drink] = []
    var coldDrinks: [Drink] = []
    
    let coffeeView = CommitCoffeeView()
    
    var isHotDrink = true
    var selectedDrink: Int? 
    
    override func loadView() {
        view = coffeeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addTargets()
        readyData()
        setCollection()
    }


    func readyData() {
        let drinkList = dataManager.getDrinkListFromAPI()
        drinkList.forEach { drink in
            if drink.isIced == false {
                hotDrinks.append(drink)
            } else {
                coldDrinks.append(drink)
            }
        }
        
    }

    
    func setUI() {
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .primaryColor500
    }
    
    func addTargets() {
        coffeeView.tempController.addTarget(self, action: #selector(controllerChanged), for: .valueChanged)
        coffeeView.continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    func setCollection() {
        // 셀 등록
        coffeeView.collectionView.delegate = self
        coffeeView.collectionView.dataSource = self
        coffeeView.collectionView.register(CommitCoffeeCollectionViewCell.self, forCellWithReuseIdentifier: CellId.commitCoffeeCell.rawValue)

    }
    
    @objc func controllerChanged() {
        isHotDrink.toggle()
        selectedDrink = nil
        coffeeView.selectedDrink.text = ""
        coffeeView.collectionView.reloadData()
    }
    
    @objc func continueButtonTapped() {
        let moodVC = CommitMoodViewController()
        moodVC.selectedDrink = selectedDrink
        navigationController?.pushViewController(moodVC, animated: false)
    
    }

}

extension CommitCoffeeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isHotDrink ? hotDrinks.count : coldDrinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = coffeeView.collectionView.dequeueReusableCell(withReuseIdentifier: CellId.commitCoffeeCell.rawValue, for: indexPath) as! CommitCoffeeCollectionViewCell
        
        let drinks = isHotDrink ? hotDrinks : coldDrinks
        let data = drinks[indexPath.item]

        cell.titleLabel.text = data.name
        cell.imageView.image = UIImage(named: data.image)        
        
        // 음료수가 선택 되었다면
        if let selectedDrink, selectedDrink == data.drinkId {
            cell.imageView.layer.shadowColor = UIColor.blue.cgColor
            cell.titleLabel.textColor = .primaryColor500
            cell.imageLayer.alpha = 1
            cell.checkIcon.alpha = 1
        } else {
            cell.imageView.layer.shadowColor = UIColor.black.cgColor
            cell.titleLabel.textColor = .black
            cell.imageLayer.alpha = 0
            cell.checkIcon.alpha = 0
            cell.backgroundColor = .white
        }
        return cell
    }    
}

// setting collection cell size
extension CommitCoffeeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 30) / 3, height: (collectionView.frame.height - 30) / 3)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let drinks = isHotDrink ? hotDrinks : coldDrinks
        let selectedData = drinks[indexPath.row]

        let drinkName = selectedData.name.uppercased()
        let tempMode = isHotDrink ? "🔥HOT" : "🧊ICED"
        self.selectedDrink = selectedData.drinkId
        coffeeView.selectedDrink.text = "\(tempMode) / \(drinkName)"
        coffeeView.collectionView.reloadData()
        coffeeView.continueButton.setTitleColor(UIColor.primaryColor500, for: .normal)
        coffeeView.continueButton.isEnabled = true
    }
}
