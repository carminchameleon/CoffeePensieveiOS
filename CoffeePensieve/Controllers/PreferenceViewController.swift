//
//  PreferenceViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/26.
//

import UIKit
import UserNotifications

class PreferenceViewController: UIViewController {
    var preferenceView = PreferenceView()
    var dataManager = DataManager.shared
    let notiCenter = DataManager.sharedNotiCenter
    
    var systemNotiSetting = true
    var reminder = true    
    
    var cups = 3
    var sectionList: [Preference] = []
    
    override func loadView() {
        view = preferenceView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTitle()
        checkNotificationStatus()
    }

    @objc func willEnterForeground() {
        checkNotificationStatus()
    }
    
    func configureTitle() {
        navigationItem.title = "Preference"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .lightGray
        tabBarController?.tabBar.isHidden = false
    }
    
    func checkNotificationStatus() {
        notiCenter.getNotificationSettings {(settings) in
           // 시스템 세팅
               if settings.authorizationStatus == .authorized {
                   // 기본 상태
                   self.systemNotiSetting = true
                   DispatchQueue.main.async {
                       // 허용되어 있는 상태라면, 내가 사전에 reminder 설정해 놓은 것으로 보여줘야 한다.
                       self.preferenceView.switchButton.isOn = self.reminder
                   }
               } else {
                   self.systemNotiSetting = false
                   DispatchQueue.main.async {
                       self.preferenceView.switchButton.isOn = false
                   }
               }
           }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserData()
        configureTableView()
        addTargets()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
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

    func addTargets() {
        preferenceView.switchButton.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        preferenceView.setButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func switchValueChanged() {
//        case 1
        // 1. System 이 false로 되어 있어서 현재 상태가 false로 되어 있는데, true로 바꾸려고 한다면
        // 2. 설정 팝업 보여주고
            // 2-1. Setting
            // 2-2. Not not -> Toggle을 다시 false로 바꿔야 함
       // case 2
        // 1.. System 이 true로 되어 있는 상태에서
        // true인데 false로 바꿀 경우 그냥 그렇게 바꾸기
        // false인데 true로 바꿀 경우 그냥 바꾸기
        let switchButton = preferenceView.switchButton
        let currentValue = switchButton.isOn
    
        if systemNotiSetting == false, currentValue == true {
            DispatchQueue.main.async {
                switchButton.isOn = false
            }
            showSystemSettingAlert()
            return
        }
        self.reminder = currentValue
    }
    
    
    // system 설정 팝업 띄우는 함수
    func showSystemSettingAlert() {
        let enableAlert = UIAlertController(title: "You've disabled notification", message: "To enable reminder, go to Setting > Notifications", preferredStyle: .alert)
             let settingAction = UIAlertAction(title: "Setting", style: .default) {action in
                 self.openAppNotificationSettings()
             }
             let laterAction = UIAlertAction(title: "Not now", style: .destructive)
             enableAlert.addAction(settingAction)
             enableAlert.addAction(laterAction)

             self.present(enableAlert, animated: true, completion: nil)
    }
    
    func openAppNotificationSettings() {
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            UIApplication.shared.open(url, options: [:]) { (success) in
                if success {
                    print("알림 설정 화면으로 이동되었습니다.")
                }
            }
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
        
        if reminder {
            Common.setNotification(type: .morning, timeString: morningTime)
            Common.setNotification(type: .night, timeString: nightTime)
            Common.setNotification(type: .limit, timeString: limitTime)
        } else {
            Common.removeNotification()
        }
    }
    
    func removeNotification(){
        notiCenter.removePendingNotificationRequests(withIdentifiers: [PreferenceTime.morning.rawValue,PreferenceTime.night.rawValue,PreferenceTime.limit.rawValue ])
    }
    
    func setNotification(type: PreferenceTime, timeString: String) {
        notiCenter.removeAllDeliveredNotifications()
        // 요청 시간 처리
        let component = timeString.components(separatedBy: ":")
        let hour = Int(component[0]) ?? 0
        let minute = Int(component[1]) ?? 0
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let isDaily = true
    
        var title = ""
        var body = ""
        // 각 타입에 맞는 텍스트 등록
        switch type {
        case .morning:
            title = Constant.NotificatonMessage.morningMessage.greeting
            body = Constant.NotificatonMessage.morningMessage.message
        case .night:
            title = Constant.NotificatonMessage.nightMessage.greeting
            body = Constant.NotificatonMessage.nightMessage.message
        case .limit:
            title = Constant.NotificatonMessage.limitMessage.greeting
            body = Constant.NotificatonMessage.limitMessage.message
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: type.rawValue, content: content, trigger: trigger)

        notiCenter.add(request) {(error) in
            if let error = error {
                print("Local Push Alert setting Fail", error.localizedDescription)
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
