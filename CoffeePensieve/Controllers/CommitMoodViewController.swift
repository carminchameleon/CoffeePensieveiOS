//
//  CommitMoodViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/05.
//

import UIKit

class CommitMoodViewController: UIViewController {

    let dataManager = DataManager.shared
    
    var moods: [Mood] = []
    let moodView = CommitMoodView()
    var selectedMood: Int?
    var selectedDrink: Int? 
    
    override func loadView() {
        view = moodView
    }
    
    let relativeFontConstant: CGFloat = 0.048
    let relativeFontConstant2: CGFloat = 0.016

    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        setMoodData()
        setCollection()
        
    }
    
    func setMoodData() {
        let moodList = dataManager.getMoodListFromAPI()
        moods = moodList
    }
    
    func addTargets() {
        moodView.continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    func setCollection() {
        moodView.collectionView.delegate = self
        moodView.collectionView.dataSource = self
        moodView.collectionView.register(CommitMoodCollectionViewCell.self, forCellWithReuseIdentifier: CellId.commitMoodCell.rawValue)
    }
    
    @objc func continueButtonTapped() {
        let tagVC = CommitTagViewController()
        tagVC.selectedMood = selectedMood
        tagVC.selectedDrink = selectedDrink
        navigationController?.pushViewController(tagVC, animated: false)
    }
}

extension CommitMoodViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moodView.collectionView.dequeueReusableCell(withReuseIdentifier: CellId.commitMoodCell.rawValue, for: indexPath) as! CommitMoodCollectionViewCell
        let data = moods[indexPath.row]
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = #colorLiteral(red: 0.1058823529, green: 0.3019607843, blue: 1, alpha: 1)
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 18
        cell.iconLabel.text = data.image
        cell.titleLabel.text = data.name
        cell.iconLabel.font = cell.iconLabel.font.withSize(self.view.frame.height * relativeFontConstant)
        cell.titleLabel.font = cell.titleLabel.font.withSize(self.view.frame.height * relativeFontConstant2)
      
        if selectedMood != nil, selectedMood! == indexPath.row {
            cell.backgroundColor = .primaryColor100
            cell.titleLabel.textColor = .primaryColor500
        } else {
            cell.backgroundColor = .white
            cell.titleLabel.textColor = .black
        }
        return cell
    }
    
}

extension CommitMoodViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 80) / 3, height: (collectionView.frame.width - 80) / 3)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mood = moods[indexPath.row]
        selectedMood = indexPath.row
        moodView.collectionView.reloadData()
        moodView.selectedMood.text = "\(mood.image) \(mood.name.uppercased())"
        moodView.continueButton.isEnabled = true
    }
    
}
