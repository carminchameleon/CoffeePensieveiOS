//
//  MoodModalViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/06.
//

import UIKit


protocol MoodControlDelegate {
    func moodSelected(mood: Mood)
}

class MoodModalViewController: UIViewController {

    var moodList = Constant.moodList
    var selectedMoodId = 0
    var delegate: MoodControlDelegate?

    let cancelButton = ModalTextButton(title: "Cancel")
    let doneButton = ModalTextButton(title: "Done")
    
    let moodPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    init(moodId: Int?) {
        super.init(nibName: nil, bundle: nil)
        if let id = moodId {
            self.selectedMoodId = id
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addTargets()
        configureMoodPicker()
    }
    
    func configureMoodPicker() {
        moodPicker.delegate = self
        moodPicker.dataSource = self
        moodPicker.selectRow(selectedMoodId, inComponent: 0, animated: true)
    }
    
    func addTargets() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
        let mood = moodList.filter { $0.moodId == selectedMoodId }[0]
        delegate?.moodSelected(mood: mood)
        dismiss(animated: true)
    }
    
    func setUI() {
        view.backgroundColor = .primaryColor25
        view.addSubview(cancelButton)
        view.addSubview(moodPicker)
        view.addSubview(doneButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            cancelButton.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        moodPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moodPicker.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 0),
            moodPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            moodPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            moodPicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            doneButton.widthAnchor.constraint(equalToConstant: 70),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            doneButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

}


extension MoodModalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return moodList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let selectedMood = moodList[row]
        let text = Common.getMoodText(selectedMood)
        return text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMoodId = moodList[row].moodId
    }
}
