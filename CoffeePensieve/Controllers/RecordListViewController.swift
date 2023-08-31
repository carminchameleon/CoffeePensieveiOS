//
//  RecordListViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/19.
//

import UIKit
import Firebase

final class RecordListViewController: UIViewController {
    let dataManager = DataManager.shared
    let trackerManager = TrackerNetworkManager.shared
    
    typealias RecordCollectionData = (dates: [Date], commits: [[CommitDetail]])
    typealias SortedDailyDetailedCommit = [Date: [CommitDetail]]
    
    var recordHeaders: [Date] = []
    var recordSections: [[CommitDetail]] = []
    let standardSize = 15
    var isFecthingNeeded = false
    var lastDocument: DocumentSnapshot? = nil
    var rawData: [Commit] = []
    
    var isNewDataUpdated = false
    var selectedItem: IndexPath?
    
    let loadingView = RecordLoadingView()
    let emptyView = RecordEmptyView()
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setUI()
        setNavigation()
        configureCollectionView()
        
        loadingView.isLoading = true
        fetchCommitData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatus(_:)), name: Notification.Name("NewCommitMade"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addSubViews() {
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        view.addSubview(loadingView)
    }
    
    @objc func updateStatus(_ notification: Notification) {
        if let isNew = notification.object as? Bool {
            isNewDataUpdated = isNew
        }
    }
    
    // 최신 데이터를 받아와야 하므로
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // docket뷰에서는 tabBar을 안보여주기 때문에
        tabBarController?.tabBar.isHidden = false
        // 데이터를 새롭게 로딩하기 때문에
        
        if isNewDataUpdated {
            resetDatas()
            fetchCommitData()
            isNewDataUpdated = false
        }
    }
    
    func resetDatas() {
        loadingView.isLoading = true
        recordHeaders = []
        recordSections = []
        isFecthingNeeded = false
        lastDocument = nil
        rawData = []
        selectedItem = nil
    }
    
    
    func fetchCommitData () {
        Task {[weak self] in
            guard let self = self else { return }
            do {
                self.isFecthingNeeded = false
                let result = try await trackerManager.fetchAllCommitsWithOffset(size: standardSize, lastDocument: lastDocument)
                let commitData = result.data
                self.lastDocument = result.snapshot
                
                if recordHeaders.isEmpty && commitData.isEmpty {
                    self.loadingView.isLoading = false
                    self.emptyView.isHidden = false
                    return
                }
            
                self.rawData.append(contentsOf: commitData)
                let newData = updateDateForm(commitList: self.rawData)

                if recordHeaders.isEmpty {
                    self.loadingView.isLoading = false
                    self.emptyView.isHidden = true
                }

                self.recordHeaders = newData.dates
                self.recordSections = newData.commits
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.isFecthingNeeded = commitData.count == self.standardSize
            } catch {
                AlertManager.showTextAlert(on: self, title: "Sorry", message: "Could not get your records")
            }
            
        }
    }
    
    func updateDateForm(commitList: [Commit]) -> RecordCollectionData {
        // 간단한 정보로 온 commit을 디테일로 바꿔줌
        let convertedCommitList = commitList.map { self.dataManager.getCommitDetailInfo(commit: $0) }
        // 날짜별로 sorting
        let sortedList = self.dataManager.sortDetailedCommitwithCreatedAt(convertedCommitList)
        return self.changeForCollectionView(data: sortedList)
    }
    
    func changeForCollectionView(data: SortedDailyDetailedCommit) -> RecordCollectionData {
        
        let sortedGroupedCommitDetails = data.sorted { $0.key > $1.key }
        // 최신 날짜로 정렬
        var headerList: [Date] = []
        var sectionData: [[CommitDetail]] = []

        sortedGroupedCommitDetails.forEach { (key: Date, value: [CommitDetail]) in
            headerList.append(key)
            let sortedCommit = value.sorted { $0.createdAt > $1.createdAt }
            sectionData.append(sortedCommit)
        }
        return (headerList, sectionData)
    }
    
    @objc func addButtonTapped() {
        let commitVC = CommitCoffeeViewController()
        navigationController?.pushViewController(commitVC, animated: true)
    }
        
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecordListCollectionViewCell.self,
                                forCellWithReuseIdentifier: CellId.RecordListCell.rawValue)
        collectionView.register(RecordHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CellId.RecordHeaderCell.rawValue)
    }

    
    func setUI() {
        view.backgroundColor = .white
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
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
        emptyView.addButton.addTarget(self, action: #selector(self.addButtonTapped), for: .touchUpInside)
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
            let commit = recordSections[sectionIndex][rowIndex]
            cell.commit = commit
        }
        return cell
    }
    
    // MARK: - 셀 선택되는 부분
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !recordSections.isEmpty {
            selectedItem = indexPath
            let sectionIndex = indexPath.section
            let rowIndex = indexPath.row
            
            let selectedItem = recordSections[sectionIndex][rowIndex]
            let docketVC = DocketViewController(commit: selectedItem)
            docketVC.delegate = self
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
            if !text.isEmpty {
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
    
    // 스크롤 마지막에 새로운 데이터 패치
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let leftContentsHeight = scrollView.contentSize.height - scrollView.frame.size.height
        let scrolledContentsHeight = scrollView.contentOffset.y
    
        if scrolledContentsHeight > leftContentsHeight {
            if isFecthingNeeded { fetchCommitData() }
        }
    }
}

extension RecordListViewController: DocketControlDelegate {
    func isDeleted() {
        if let selected = selectedItem {
            let sectionIndex = selected.section
            let rowIndex = selected.row
            
            if self.recordSections[sectionIndex].count == 1 {
                self.recordHeaders.remove(at: sectionIndex)
                self.recordSections.remove(at: sectionIndex)
                self.collectionView.deleteSections(IndexSet(integer: sectionIndex))
                
                if self.recordHeaders.isEmpty {
                    DispatchQueue.main.async {
                        self.emptyView.isHidden = false
                    }
                }
            } else {
                self.recordSections[sectionIndex].remove(at: rowIndex)
                self.collectionView.deleteItems(at: [selected])
            }
        }
    }
}


