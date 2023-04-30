//
//  FirstProfileRoutineViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/16.
//

import UIKit

class FirstProfileRoutineViewController: UIViewController {

    let routineView = FirstProfileRoutineView()
    let networkManager = AuthNetworkManager.shared
    
    var name = ""
    var limitTime = "17:00"
    var cups = 3
    var morningTime = "7:00"
    var nightTime = "22:00"
    var email = ""
    var password = ""
    
    
    override func loadView() {
        view = routineView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        addTargets()
    }
    
    
    func setUp() {
        routineView.cupCountLabel.text = String(cups)
        routineView.cupStepper.value = Double(cups)
        initTimePicker(time: morningTime, picker: routineView.morningTimePicker)
        initTimePicker(time: nightTime, picker: routineView.nightTimePicker)
        initTimePicker(time: limitTime, picker: routineView.limitTimePicker)
        routineView.nameTextField.becomeFirstResponder()
    }
    
    func initTimePicker(time: String, picker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let date = dateFormatter.date(from: time) {
            picker.date = date
        }
    }
    
    func addTargets() {
        routineView.morningTimePicker.addTarget(self, action: #selector(morningTimePickerValueChanged), for: .valueChanged)
        routineView.nightTimePicker.addTarget(self, action: #selector(nightTimePickerValueChanged), for: .valueChanged)
        routineView.limitTimePicker.addTarget(self, action: #selector(limitPickerValueChanged), for: .valueChanged)
        routineView.cupStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        routineView.nameTextField.addTarget(self, action: #selector(nameValueChanged(_:)), for: .editingChanged)
        routineView.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchDown)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
    
    @objc func morningTimePickerValueChanged() {
        morningTime = getTimeString(date: routineView.morningTimePicker.date)
        print(morningTime)
    }
    
    @objc func nightTimePickerValueChanged() {
        nightTime = getTimeString(date:routineView.nightTimePicker.date)
    }
    
    @objc func limitPickerValueChanged() {
        limitTime = getTimeString(date: routineView.limitTimePicker.date)
    }
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        let cup = Int(sender.value)
        routineView.cupCountLabel.text = String(cup)
        cups = cup
    }
    
    @objc func nameValueChanged(_ sender: UITextField) {

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
    
    @objc func submitButtonTapped() {
        
        networkManager.signUp(email: email, password: password, name: name, morningTime: morningTime, nightTime: nightTime, limitTime: limitTime, cups: cups) { error in
            let alert = UIAlertController(title: "Sorry", message: error.localizedDescription, preferredStyle: .alert)
            let tryAgain = UIAlertAction(title: "Okay", style: .default) { action in
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            }
            alert.addAction(tryAgain)
            self.present(alert, animated: true, completion: nil)
            
        }
    }

    // 시간설정 절대적으로 바꿔줌
    // 오후 1시 -> 13:00
    // 오전 1시 -> 01:00
    func getTimeString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
    
    
}
