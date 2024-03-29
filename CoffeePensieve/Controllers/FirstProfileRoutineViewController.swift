//
//  FirstProfileRoutineViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/16.
//

import UIKit
import Firebase

final class FirstProfileRoutineViewController: UIViewController {

    private let routineView = FirstProfileRoutineView()
    let networkManager = AuthNetworkManager.shared
    let notiCenter = LocalNotification.sharedNotiCenter

    var name = ""
    var limitTime = "17:00"
    var cups = 3
    var morningTime = "7:00"
    var nightTime = "22:00"
    var email = ""
    var password = ""
    var reminder = true
    var isSocial = false
    
    override func loadView() {
        view = routineView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        addTargets()
        checkNotificationStatus()
    }
    
    
    private func setUp() {
        routineView.cupCountLabel.text = String(cups)
        routineView.cupStepper.value = Double(cups)
        initTimePicker(time: morningTime, picker: routineView.morningTimePicker)
        initTimePicker(time: nightTime, picker: routineView.nightTimePicker)
        initTimePicker(time: limitTime, picker: routineView.limitTimePicker)
        routineView.nameTextField.becomeFirstResponder()
    }

    private func addTargets() {
        routineView.morningTimePicker.addTarget(self, action: #selector(morningTimePickerValueChanged), for: .valueChanged)
        routineView.nightTimePicker.addTarget(self, action: #selector(nightTimePickerValueChanged), for: .valueChanged)
        routineView.limitTimePicker.addTarget(self, action: #selector(limitPickerValueChanged), for: .valueChanged)
        routineView.cupStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        routineView.nameTextField.addTarget(self, action: #selector(nameValueChanged(_:)), for: .editingChanged)
        routineView.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchDown)
    }

    
    private func initTimePicker(time: String, picker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let date = dateFormatter.date(from: time) {
            picker.date = date
        }
    }

    private func checkNotificationStatus() {
        notiCenter.getNotificationSettings { (settings) in
            self.reminder = settings.authorizationStatus == .authorized
       }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
    
    @objc private func morningTimePickerValueChanged() {
        morningTime = Common.getTimeToString(date: routineView.morningTimePicker.date)
    }
    
    @objc private func nightTimePickerValueChanged() {
        nightTime = Common.getTimeToString(date: routineView.nightTimePicker.date)
    }
    
    @objc private func limitPickerValueChanged() {
        limitTime = Common.getTimeToString(date: routineView.limitTimePicker.date)
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        let cup = Int(sender.value)
        routineView.cupCountLabel.text = String(cup)
        cups = cup
    }
    
    @objc private func nameValueChanged(_ sender: UITextField) {
        if sender.text?.first == " " {
            sender.text = ""
               return
       }
        guard let userName = sender.text else { return }
        if userName.count > 0 {
            routineView.submitButton.isEnabled = true
            routineView.submitButton.setImageTintColor(.primaryColor500)
        } else {
            routineView.submitButton.isEnabled = false
            routineView.submitButton.setImageTintColor(.primaryColor200)
        }
        
        self.name = userName
        if userName.count > 20 {
            routineView.nameTextField.resignFirstResponder()
        }
    }
    
    @objc private func submitButtonTapped() {
        let userData = SignUpForm(email: email, password: password, name: name, cups: cups, morningTime: morningTime, nightTime: nightTime, limitTime: limitTime, reminder: reminder)
        self.routineView.submitButton.isEnabled = false
        if isSocial {
            guard let currentUser = Auth.auth().currentUser else {
                self.showErrorAlert()
                return
            }
            guard let userEmail = currentUser.email else {
                self.showErrorAlert()
                return
            }
            let uid = currentUser.uid
            
            let socialForm = UploadForm(uid: uid, email: userEmail, name: name, cups: cups, morningTime: morningTime, nightTime: nightTime, limitTime: limitTime, reminder: reminder)
            networkManager.uploadUserProfile(userData: socialForm) {[weak self] error in
                guard let weakSelf = self else { return }
                let alert = UIAlertController(title: "Sorry", message: error.localizedDescription, preferredStyle: .alert)
                let tryAgain = UIAlertAction(title: "Okay", style: .default) { action in
                    weakSelf.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                }
                alert.addAction(tryAgain)
                weakSelf.present(alert, animated: true, completion: nil)
                return
            }
            let completeVC = FirstProfileCompleteViewController()
            self.navigationController?.pushViewController(completeVC, animated: true)
            
        } else {
            networkManager.signUp(userData) {[weak self] error in
                guard let weakSelf = self else { return }

                let alert = UIAlertController(title: "Sorry", message: error.localizedDescription, preferredStyle: .alert)
                let tryAgain = UIAlertAction(title: "Okay", style: .default) { action in
                    weakSelf.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                }
                alert.addAction(tryAgain)
                weakSelf.present(alert, animated: true, completion: nil)
                return
            }
        }
        
        if reminder {
            LocalNotification.setNotification(type: .morning, timeString: morningTime)
            LocalNotification.setNotification(type: .night, timeString: nightTime)
            LocalNotification.setNotification(type: .limit, timeString: limitTime)
        }
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Sorry", message: "Failed to make your profile. If this error continues to occur, please contact the administrator.", preferredStyle: .alert)
        let tryAgain = UIAlertAction(title: "Okay", style: .default) {[weak self] action in
            guard let weakSelf = self else { return }
            weakSelf.networkManager.signOut()
        }
        alert.addAction(tryAgain)
        self.present(alert, animated: true, completion: nil)
    }


    
}
