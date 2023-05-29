//
//  PreferenceViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/26.
//

import UIKit

class PreferenceViewController: UIViewController {
    
    var preferenceView = PreferenceView()
    var dataManager = DataManager.shared
    
    var reminder = true {
        didSet {
            preferenceView.switchButton.setOn(reminder, animated: true)
        }
    }
    
    var cups = 3
    var sectionList: [Preference] = []
    
    override func loadView() {
        view = preferenceView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTitle()
    }
    
    func configureTitle() {
        navigationItem.title = "Preference"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .lightGray
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserData()
        configureTableView()
        addTargets()
    }
    

    func addTargets() {
        preferenceView.switchButton.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        preferenceView.setButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    func setUserData() {
        guard let user = self.dataManager.getUserData() else { return }
        cups = user.cups
        reminder = user.reminder

        sectionList = [
            Preference(sectionTitle: "Caffeine Limit", rowList: [
                PreferenceCell(title: "Cups", icon: "cup.and.saucer", data: "\(self.cups) Cups"),
                PreferenceCell(title: "Time", icon: "deskclock", data: user.limitTime)
            ]),
            Preference(sectionTitle: "Your Daily Routine", rowList: [
                PreferenceCell(title: "Wake Up", icon: "sun.max", data: user.morningTime),
                PreferenceCell(title: "Go To Sleep", icon: "bed.double", data: user.nightTime)
            ])
        ]
        self.preferenceView.tableView.reloadData()
    }
    
    @objc func switchValueChanged() {
        reminder = preferenceView.switchButton.isOn
    }
    
    @objc func saveButtonTapped() {
        
        let limitTime = sectionList[0].rowList[1].data
        let morningTime = sectionList[1].rowList[0].data
        let nightTime = sectionList[1].rowList[1].data
        let userData = UserPreference(cups: cups, morningTime: morningTime, nightTime: nightTime, limitTime: limitTime, reminder: reminder)
        
        dataManager.updateUserPreference(data: userData) {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                strongSelf.navigationController?.popViewController(animated: true)
            case .failure:
                let failAlert = UIAlertController(title: "Sorry", message: "Fail to update your preference.\n Please try again later", preferredStyle: .alert)
               let okayAction = UIAlertAction(title: "Okay", style: .default) {action in
                   strongSelf.navigationController?.popViewController(animated: true)
               }
               failAlert.addAction(okayAction)
               strongSelf.present(failAlert, animated: true, completion: nil)
            }
        }
    }


    func configureTableView() {
        preferenceView.tableView.delegate = self
        preferenceView.tableView.dataSource = self

        preferenceView.tableView.register(PreferenceTimeTableViewCell.self, forCellReuseIdentifier: CellId.PreferenceTimeCell.rawValue)
        preferenceView.tableView.register(PreferenceCupTableViewCell.self, forCellReuseIdentifier: CellId.PreferenceCupCell.rawValue)
        preferenceView.tableView.rowHeight = 50
    }
    
}

extension PreferenceViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = PreferenceHeaderView()
        let title = sectionList[section].sectionTitle
        header.titleLabel.text = title
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionList[section].rowList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        let rowData = sectionList[sectionIndex].rowList[rowIndex]
    
//        if sectionIndex == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellId.PreferenceNameCell.rawValue, for: indexPath) as! PreferenceTableViewCell
//            cell.contentView.isUserInteractionEnabled = false
//            cell.model = rowData
//            cell.nameTextField.delegate = self
//            cell.handleNameField = {(sender) in
//                guard let userName = sender.text else { return }
//                // 20자 넘어가면 등록 안되게 하는 것
//                if userName.count > 20 {
//                    cell.nameTextField.resignFirstResponder()
//                }
//            }
//            return cell
//
//        } else
        if sectionIndex == 0 && rowIndex == 0  {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId.PreferenceCupCell.rawValue, for: indexPath) as! PreferenceCupTableViewCell
            cell.model = rowData
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellId.PreferenceTimeCell.rawValue, for: indexPath) as! PreferenceTimeTableViewCell
            cell.model = rowData
            return cell
        }
        
    }


    // 셀이 선택 되었을 때 진행
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        let data = sectionList[sectionIndex].rowList[rowIndex].data
        
        if sectionIndex == 0 {
            switch rowIndex {
            case 0:
                let cupModalVC = CupModalViewController(cups: cups)
                cupModalVC.delegate = self
                resizeModalController(modalVC: cupModalVC)
                present(cupModalVC, animated: true, completion: nil)
            default:
                let timeModalVC = TimeModalViewController(type:.limit, time: data)
                timeModalVC.delegate = self
                resizeModalController(modalVC: timeModalVC)
                present(timeModalVC, animated: true, completion: nil)
            }
            
        } else if sectionIndex == 1 {
            let type: PreferenceTime = rowIndex == 0 ? .morning : .night
            let timeModalVC = TimeModalViewController(type: type, time: data)
            timeModalVC.delegate = self
            resizeModalController(modalVC: timeModalVC)
            present(timeModalVC, animated: true, completion: nil)
        }
    }
    
    // 모달 사이즈 중간으로 맞추기
    func resizeModalController(modalVC: UIViewController) {
        navigationController?.modalPresentationStyle = .overCurrentContext
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [ .custom(identifier: .medium) { context in 0.4 * context.maximumDetentValue },
                              .medium() ]
        }
    }
}

extension PreferenceViewController : CupControlDelegate {
    func cupSelected(number: Int) {
        cups = number
        sectionList[0].rowList[0].data = "\(number) Cups"
        DispatchQueue.main.async {
            self.preferenceView.tableView.reloadData()
        }

    }
}


extension PreferenceViewController : TimeControlDelegate {
    
    func timeSelected(type: PreferenceTime, time: String) {
        switch type {
        case .limit:
            sectionList[0].rowList[1].data = time
        case .morning:
            sectionList[1].rowList[0].data = time
        case .night:
            sectionList[1].rowList[1].data = time

        }
        DispatchQueue.main.async {
            self.preferenceView.tableView.reloadData()
        }
    }
}
