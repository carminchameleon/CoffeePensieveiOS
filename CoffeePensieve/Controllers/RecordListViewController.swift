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
    let emptyView = RecordEmptyView()
    let dataManager = DataManager.shared
    
    typealias SortedDailyDetailedCommit = [Date: [CommitDetail]]
    
    var recordHeaders: [Date] = []
    var recordSections: [[CommitDetail]] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let totalCount = dataManager.getCommitCount()
        if totalCount == 0 {
            // 테이블 데이터 없음 셀 보여줘야 함.
            view = emptyView
            emptyView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
            tabBarController?.tabBar.isHidden = false
            return
        }
        
        readyData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                let allCommitList = self.dataManager.getAllCommits()
                let sortedList = self.dataManager.sortDetailedCommitwithCreatedAt(allCommitList)
                self.changeForCollectionView(data: sortedList)

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
    
    @objc func addButtonTapped() {
        let commitVC = CommitCoffeeViewController()
        navigationController?.pushViewController(commitVC, animated: true)
    }
        
    func changeForCollectionView(data: SortedDailyDetailedCommit) {
        let sortedGroupedCommitDetails = data.sorted { $0.key > $1.key }
        var headerList: [Date] = []
        var sectionData: [[CommitDetail]] = []

        sortedGroupedCommitDetails.forEach { (key: Date, value: [CommitDetail]) in
            headerList.append(key)
            let sortedCommit = value.sorted { $0.createdAt > $1.createdAt }
            sectionData.append(sortedCommit)
        }
        
        self.recordHeaders = headerList
        self.recordSections = sectionData
    }

        
        func setUI() {
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
            collectionView.register(RecordHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellId.RecordHeaderCell.rawValue)

        }

}

extension RecordListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recordHeaders.isEmpty ? 1 : recordHeaders.count
    }
    // MARK: - 섹션에 해당하는 데이터 셀 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if recordHeaders.isEmpty {
            return 6
        } else {
            return recordSections[section].count
        }
    }
    

    // MARK: - 데이터 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.RecordListCell.rawValue, for: indexPath) as! RecordListCollectionViewCell

        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        
        if !recordSections.isEmpty {
            let commit = recordSections[sectionIndex][rowIndex]
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
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        
        let selectedItem = recordSections[sectionIndex][rowIndex]
        let docketVC = DocketViewController(commit: selectedItem)
                navigationController?.pushViewController(docketVC, animated: true)
    }
    
}

extension RecordListViewController: UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // 헤더 뷰의 크기를 반환합니다.
        return CGSize(width: collectionView.bounds.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 40
        var height: CGFloat = 100
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        
        if !recordSections.isEmpty {
            let data = recordSections[sectionIndex][rowIndex]
            let text = data.memo
            if text != "" {
                let font = UIFont.systemFont(ofSize: 14, weight: .light)
                height = height + Common.heightForView(text: text, font: font, width: width) + 12
                height = height > 163 ? 163 : height
            }
        }
        return CGSize(width: (collectionView.frame.width - 40), height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
     
        if kind == UICollectionView.elementKindSectionHeader {
               // 헤더 뷰를 가져옵니다.
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellId.RecordHeaderCell.rawValue, for: indexPath) as! RecordHeaderCollectionReusableView

            if !recordHeaders.isEmpty {
              
                let createdAt = recordHeaders[indexPath.section]
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "En")
                dateFormatter.dateFormat = "EEEE, d MMMM"
                let formattedCreatedAt = dateFormatter.string(from: createdAt)
                headerView.titleLabel.text = formattedCreatedAt
            } else {
                headerView.titleLabel.text = ""
            }
               return headerView
           }
           
           // 푸터 뷰를 반환하는 경우에 대한 처리도 추가할 수 있습니다.
        assert(false, "Unexpected element kind")
    }
    
    
}

