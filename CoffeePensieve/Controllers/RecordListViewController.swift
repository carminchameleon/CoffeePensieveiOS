//
//  RecordListViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/19.
//

import UIKit

class RecordListViewController: UIViewController {

    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return cv
    }()
    
    let dataManager = DataManager.shared
    var allCommitList: [CommitDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        readyData()
        setUI()
        setCollection()
        setNavigation()
    }
    func setNavigation() {
        navigationItem.title = "Memories"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .primaryColor500
    }
    
    
        func readyData() {
            dataManager.fetchAllCommits { result in
                switch result {
                case .success:
                    self.allCommitList = self.dataManager.getAllCommits()
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                case .failure:
                    let alert = UIAlertController(title: "Sorry", message: "Could not load your record list", preferredStyle: .alert)
                    let tryAgain = UIAlertAction(title: "Okay", style: .default) { action in
                        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                    }
                    alert.addAction(tryAgain)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
        func setUI() {
            print(#function)
            view.backgroundColor = .white
            view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        func setCollection() {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(RecordListCollectionViewCell.self, forCellWithReuseIdentifier: CellId.RecordListCell.rawValue)
        }

}

extension RecordListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCommitList.isEmpty ? 6 : allCommitList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.RecordListCell.rawValue, for: indexPath) as! RecordListCollectionViewCell
        
        // 로딩중일 때
        if !allCommitList.isEmpty {
            let commit = allCommitList[indexPath.item]
            
            cell.timeLabel.text = Common.changeDateToString(date: commit.createdAt)
            cell.drinkImage.image = UIImage(named: commit.drink.image)
            let tempMode = commit.drink.isIced ? "🧊ICED" : "🔥HOT"
            cell.drinkLabel.text = "\(tempMode) \(commit.drink.name.uppercased())"
            cell.moodLabel.text = commit.mood.image
            cell.tagLabel.text = commit.tagList.reduce("", { $0 + " " + "#\($1.name)" })
            cell.memoLabel.text = commit.memo
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 12
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = allCommitList[indexPath.row]
        let docketVC = DocketViewController(commit: selectedItem)
                navigationController?.pushViewController(docketVC, animated: true)
    }
    
}

extension RecordListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 40
        var height: CGFloat = 100
        
        if !allCommitList.isEmpty {
            let text = allCommitList[indexPath.row].memo
            if text != "" {
                let font = UIFont.systemFont(ofSize: 14, weight: .light)
                height = height + Common.heightForView(text: text, font: font, width: width) + 12
                height = height > 163 ? 163 : height
            }
        }
        return CGSize(width: (collectionView.frame.width - 40), height: height)
    }
}

