//
//  RecordListViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/19.
//

import UIKit

class RecordListViewController: UIViewController {
    
    let dataManager = DataManager.shared
    
    typealias SortedDailyDetailedCommit = [Date: [CommitDetail]]
    
    var recordHeaders: [Date] = [] {
        didSet {
            print(recordHeaders)
        }
    }
    
    var recordSections: [[CommitDetail]] = [] {
        didSet {
            print(recordHeaders)
        }
    }
    
    private let loadingView: RecordLoadingView = {
        let view = RecordLoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyView: RecordEmptyView = {
        let view = RecordEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        self.view.addSubview(emptyView)
        self.view.addSubview(loadingView)
        
        self.emptyView.addButton.addTarget(self, action: #selector(self.addButtonTapped), for: .touchUpInside)

        setNavigation()
        setUI()
        setCollection()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
        self.loadingView.isLoading = true
        dataManager.fetchAllCommits {[weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success:
                // 데이터 리스트 받아오기
                let allCommitList = weakSelf.dataManager.getAllCommits()
                // No Commits
                if allCommitList.count == 0 {
                    DispatchQueue.main.async {
                       weakSelf.loadingView.isLoading = false
                       weakSelf.emptyView.isHidden = false
                   }
                } else {
                    // 데이터 원하는 식으로 변형 하기
                    let sortedList = weakSelf.dataManager.sortDetailedCommitwithCreatedAt(allCommitList)
                    weakSelf.changeForCollectionView(data: sortedList)
                    // 그 다음에 데이터를 바꿔서 로드하기
                    DispatchQueue.main.async {
                        weakSelf.loadingView.isLoading = false
                        weakSelf.emptyView.isHidden = true
                        weakSelf.collectionView.reloadData()
                    }
                }
            case .failure:
                weakSelf.showErrorAlert()
            }
        }
    }
    
    @objc func addButtonTapped() {
        let commitVC = CommitCoffeeViewController()
        navigationController?.pushViewController(commitVC, animated: true)
    }
        
    
    func setUI() {
        view.backgroundColor = .white

        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])

        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setNavigation() {
          navigationItem.title = "Memories"
          navigationController?.navigationBar.prefersLargeTitles = false
          navigationController?.navigationBar.tintColor = .primaryColor500
    }
    
    func showErrorAlert() {
          let alert = UIAlertController(title: "Sorry", message: "Could not get your records", preferredStyle: .alert)
          let tryAgain = UIAlertAction(title: "Okay", style: .default)
          alert.addAction(tryAgain)
          self.present(alert, animated: true, completion: nil)
    }
    
    func setCollection() {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(RecordListCollectionViewCell.self, forCellWithReuseIdentifier: CellId.RecordListCell.rawValue)
            collectionView.register(RecordHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellId.RecordHeaderCell.rawValue)
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
    
}

extension RecordListViewController: UICollectionViewDataSource {
    
    // Section 수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recordHeaders.count
    }
    
    // 하나의 Section에 들어갈 Cell의 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordSections.count == 0 ? 0 : recordSections[section].count
    }
    
    
    // Cell 안에 들어갈 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.RecordListCell.rawValue, for: indexPath) as! RecordListCollectionViewCell
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 12
        
        if !recordSections.isEmpty {
            let sectionIndex = indexPath.section
            let rowIndex = indexPath.row
            
            print("Section Index", sectionIndex)
            print("row Index", rowIndex)
            
            let commit = recordSections[sectionIndex][rowIndex]
            cell.commit = commit
        }
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !recordSections.isEmpty {
            let sectionIndex = indexPath.section
            let rowIndex = indexPath.row
            
            let selectedItem = recordSections[sectionIndex][rowIndex]
            let docketVC = DocketViewController(commit: selectedItem)
            navigationController?.pushViewController(docketVC, animated: true)
        }
    }
    
}

extension RecordListViewController: UICollectionViewDelegateFlowLayout {

    // 헤더 크기 조절
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    
    // 유동적으로 cell의 크기를 조절 하는 것
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 40
        var height: CGFloat = 100
        if !recordSections.isEmpty {
            let sectionIndex = indexPath.section
            let rowIndex = indexPath.row
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
    
    
    
    // 헤더 뷰
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
        fatalError("Unexpected element kind")
    }
}
