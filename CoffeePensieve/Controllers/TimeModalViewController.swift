//
//  TimeModalViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/28.
//

import UIKit

// 세가지의 용도로 쓰일 것임
enum PreferenceTime: String {
    case morning
    case night
    case limit
}

protocol TimeControlDelegate: AnyObject {
    func timeSelected(type: PreferenceTime, time: String)
}

class TimeModalViewController: UIViewController {
    // 어떤 데이터 인지
    var type: PreferenceTime?
    // 선택된 시간
    var selectedTime = "11:00"
    
    weak var delegate: TimeControlDelegate?
    // MARK: - 취소 버튼
    let cancelButton: UIButton = {
        let button = UIButton(type:.custom)
        let iconImage = UIImage(systemName: "xmark")
        let resizedImage = iconImage?.resized(toWidth: 20) // 아이콘 사이즈 설정
        button.setImage(resizedImage, for: .normal)
        button.setImageTintColor(.black) // 아이콘 색 설정
        return button
    }()
    
    let timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "en_US")
        return datePicker
    }()
    
    let setButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Set time", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .primaryColor500
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        return button
    }()

    init(type: PreferenceTime, time: String) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
        self.selectedTime = time
        
        // String 형식 들어오면 맞춰서 넣기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let date = dateFormatter.date(from: time) {
            timePicker.date = date
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addTargets()
    }
    
    func setUI() {
        view.backgroundColor = .primaryColor25
        
        view.addSubview(cancelButton)
        view.addSubview(timePicker)
        view.addSubview(setButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            cancelButton.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 0),
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            timePicker.bottomAnchor.constraint(equalTo: setButton.topAnchor, constant: -8)
        ])
        
        setButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            setButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            setButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            setButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
    
    func addTargets() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        setButton.addTarget(self, action: #selector(setButtonTapped), for: .touchUpInside)
        timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(handleDatePickerTap), for: .editingDidBegin)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func setButtonTapped() {
        guard let type = type else { return }
        delegate?.timeSelected(type: type, time: selectedTime)
        dismiss(animated: true)
    }
    
    @objc func timePickerValueChanged() {
        selectedTime = Common.getTimeToString(date: timePicker.date)
    }
    
    @objc func handleDatePickerTap() {
        timePicker.resignFirstResponder()
    }
}
