//
//  CupModalViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/05/28.
//

import UIKit

protocol CupControlDelegate {
    func cupSelected(number: Int)
}

class CupModalViewController: UIViewController {
    
    let numbers = [1,2,3,4,5,6,7,8,9,10]
    var cups = 4
    
    var delegate: CupControlDelegate?
    
    // MARK: - 취소 버튼
    let cancelButton: UIButton = {
        let button = UIButton(type:.custom)
        let iconImage = UIImage(systemName: "xmark")
        let resizedImage = iconImage?.resized(toWidth: 20) // 아이콘 사이즈 설정
        button.setImage(resizedImage, for: .normal)
        button.setImageTintColor(.black) // 아이콘 색 설정
        return button
    }()
    
    let cupPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    let setButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Set cups", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .primaryColor500
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        return button
    }()
    
    init(cups: Int) {
        super.init(nibName: nil, bundle: nil)
        self.cups = cups
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cupPicker.delegate = self
        cupPicker.dataSource = self
        cupPicker.selectRow(cups - 1, inComponent: 0, animated: true)
        setUI()
        addTargets()
    }
    
    func setUI() {
        view.backgroundColor = .primaryColor25
        
        view.addSubview(cancelButton)
        view.addSubview(cupPicker)
        view.addSubview(setButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            cancelButton.heightAnchor.constraint(equalToConstant: 20),
        ])
        cupPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cupPicker.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 0),
            cupPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cupPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            cupPicker.bottomAnchor.constraint(equalTo: setButton.topAnchor, constant: -8)
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
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func setButtonTapped() {
        delegate?.cupSelected(number: cups)
        dismiss(animated: true)
    }
}

extension CupModalViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(numbers[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cups = numbers[row]
    }
}
