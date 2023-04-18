//
//  FirstProfileRoutineViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/04/16.
//

import UIKit

class FirstProfileRoutineViewController: UIViewController {

    let routineView = FirstProfileRoutineView()
    let name = ""
    var morningTime = ""
    var nightTime = ""
    var limitTime = ""
    var cups = 3
    
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
        routineView.nameTextField.becomeFirstResponder()
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

        guard let name = sender.text else { return }
        if name.count > 0 {
            print("pass")
            routineView.submitButton.isEnabled = true
            routineView.submitButton.setImageTintColor(.primaryColor500)
        } else {
            routineView.submitButton.isEnabled = false
            routineView.submitButton.setImageTintColor(.primaryColor200)
        }

        
        if name.count > 20 {
            routineView.nameTextField.resignFirstResponder()
        }
    }
    
    @objc func submitButtonTapped() {
        
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.color = .primaryColor500
        // Place the activity indicator on the center of your current screen
        activityIndicator.center = routineView.center

        // In most cases this will be set to true, so the indicator hides when it stops spinning
        activityIndicator.hidesWhenStopped = true

        // Start the activity indicator and place it onto your view
        activityIndicator.startAnimating()
        routineView.addSubview(activityIndicator)


        // Do something here, for example fetch the data from API
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            activityIndicator.stopAnimating()
                        
            let completeVC = FirstProfileCompleteViewController()
            completeVC.modalPresentationStyle = .fullScreen
            self.present(completeVC, animated: true)
            
        }

        // Finally after the job above is done, stop the activity indicator
//        activityIndicator.stopAnimating()
        // DispatchQueue.main.async {self.myActivityIndicator.stopAnimating()}
    }
    func getTimeString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
    
    
}
