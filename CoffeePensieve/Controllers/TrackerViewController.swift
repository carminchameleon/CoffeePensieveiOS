//
//  TrackerViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/12.
//

import UIKit

class TrackerViewController: UIViewController {
    
    let dataManager = DataManager.shared
    
    var isTodayLoading = true
    var isGuidelineLoading = true
    var isRecordLoading = true
    
    var todayCommits: [Commit] = []
    var guideline: Guideline?
    var record: [Summary] = [Summary(title: "Your All Coffee Memories", number: 0),Summary(title: "This Week", number: 0),Summary(title: "This Month", number: 0),Summary(title: "This Year", number: 0)]
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .white
        tableView.allowsSelection = true
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchTodayData()
        self.fetchRecordData()
        self.configureTitle()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    // MARK: - set title style
    func configureTitle() {
        navigationItem.title = "Tracker"
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .primaryColor500
        tabBarController?.tabBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    @objc func addButtonTapped() {
        let coffeeVC = CommitCoffeeViewController()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.pushViewController(coffeeVC, animated: true)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        setTableViewConstraint()
        setTableViewRegister()
    }
    
    func setTableViewDelegates() {
        tableView.rowHeight = 120
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setTableViewConstraint() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setTableViewRegister() {
        tableView.register(TrackerLoadingTableViewCell.self, forCellReuseIdentifier: CellId.trackerLoadingCell.rawValue)
        tableView.register(TrackerTodayTableViewCell.self, forCellReuseIdentifier: CellId.trackerTodayCell.rawValue)
        tableView.register(TrackerGuidelineTableViewCell.self, forCellReuseIdentifier: CellId.trackerGuidlineCell.rawValue)
        tableView.register(TrackerRecordTableViewCell.self, forCellReuseIdentifier: CellId.trackerRecordCell.rawValue)
        
        
        // header
        tableView.register(TrackerTodayHeaderView.self, forHeaderFooterViewReuseIdentifier: CellId.trackerTodayHeader.rawValue)
    }
    
    func fetchTodayData() {
        // 오늘의 커피 데이터 -> 가이드 라인 계산 이루어져야 함
        dataManager.fetchTodayCommits { result in
            switch result {
            case .success:
                self.todayCommits = self.dataManager.getTodayCommits()
                self.guideline = self.dataManager.getGuidlineData()
                self.isTodayLoading = false
                self.isGuidelineLoading = false
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure:
                self.showFailAlert()
            }
        }

    }
    
    func showFailAlert() {
        let failAlert = UIAlertController(title: "Something's wrong", message: "Please check your internet connection and try again", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) {action in
            self.dismiss(animated: true)
        }
        failAlert.addAction(okayAction)
        self.present(failAlert, animated: true, completion: nil)
    }
    
    // Record 부분에 들어갈 데이터
    func fetchRecordData() {
        // 아직 commitCount = 0 인 경우 -> 조회해올 필요 없음
        dataManager.getTrackerRecord { result in
            switch result {
            case .success:
                self.isRecordLoading = false
                self.record = self.dataManager.getSummaryData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure:
                print("데이터 로드 실패 뷰 보여주기")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellId.trackerTodayHeader.rawValue) as! TrackerTodayHeaderView
        switch section {
        case 0:
            headerView.titleLabel.text = "Today's Memory"
            headerView.button.isHidden = true
        case 1:
            headerView.titleLabel.text = "Guideline"
            headerView.button.setTitle("Edit", for: .normal)
            headerView.button.setTitleColor(.primaryColor200, for: .normal)
            headerView.button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)

        case 2:
            
            headerView.titleLabel.text = "Record"
            headerView.button.isHidden = false
            headerView.button.setTitle("Show More", for: .normal)
            headerView.button.addTarget(self, action: #selector(showMoreButtonTapped), for: .touchUpInside)
        default:
            break
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func showMoreButtonTapped() {
        
        let calendarVC = CalendarViewController()
        navigationController?.pushViewController(calendarVC, animated: false)
    }
    
    @objc func editButtonTapped() {
        let preferenceVC = PreferenceViewController()
        navigationController?.pushViewController(preferenceVC, animated: false)
    }
}


extension TrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return todayCommits.isEmpty ? 1 : todayCommits.count
        case 1 :
            return 1
        case 2 :
            return 4
        default:
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            // today 데이터가 있다면
            if !todayCommits.isEmpty {
                let commit = todayCommits[indexPath.row]
                let commitDetail = dataManager.getCommitDetailInfo(commit: commit)
                let docketVC = DocketViewController(commit: commitDetail)
                navigationController?.pushViewController(docketVC, animated: true)
            }
        case 1:
            print("GuideLine")
        case 2:
            print("Record")
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        case 1:
            return 90
        case 2:
            return 40
        default:
            return UITableView.automaticDimension
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if isTodayLoading {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellId.trackerLoadingCell.rawValue, for: indexPath) as! TrackerLoadingTableViewCell
                cell.title = "Bring your today's memory 😇"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellId.trackerTodayCell.rawValue, for: indexPath) as! TrackerTodayTableViewCell
                if !todayCommits.isEmpty {
                    cell.commit = todayCommits[indexPath.row]
                }
                return cell
            }
            
            case 1:
            if isGuidelineLoading {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellId.trackerLoadingCell.rawValue, for: indexPath) as! TrackerLoadingTableViewCell
                cell.title = "Checking your guideline 🔥"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellId.trackerGuidlineCell.rawValue, for: indexPath) as! TrackerGuidelineTableViewCell
                cell.guideline = self.guideline
                return cell
            }
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: CellId.trackerRecordCell.rawValue, for: indexPath) as! TrackerRecordTableViewCell
                 cell.summary = self.record[indexPath.row]
                 return cell
            default:
            fatalError("Invalid section")
        }

    }
}
