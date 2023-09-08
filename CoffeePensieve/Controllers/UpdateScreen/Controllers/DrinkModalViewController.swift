//
//  DrinkModalViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/06.
//

import UIKit

protocol DrinkControlDelegate {
    func drinkSelected(drink: Drink)
}

class DrinkModalViewController: UIViewController {
    
    var drinkList: [Drink] {
        let newList = Constant.drinkList.sorted { firstDrink, secondDrink in
            return firstDrink.drinkId < secondDrink.drinkId
        }
        return newList
    }
    
    var selectedDrinkId = 0
    var delegate: DrinkControlDelegate?

    let cancelButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.primaryColor500, for: .normal)
        return button
    }()
    
    let drinkPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    let setButton: UIButton = {
        let button = UIButton(type:.custom)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.primaryColor500, for: .normal)
        return button
    }()
    
    init(drinkId: Int?) {
        super.init(nibName: nil, bundle: nil)
        if let id = drinkId {
            self.selectedDrinkId = id
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addTargets()
        configureDrinkPicker()
    }
    
    func configureDrinkPicker() {
        drinkPicker.delegate = self
        drinkPicker.dataSource = self
        drinkPicker.selectRow(selectedDrinkId, inComponent: 0, animated: true)
    }
    
    func addTargets() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        setButton.addTarget(self, action: #selector(setButtonTapped), for: .touchUpInside)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func setButtonTapped() {
        let drink = drinkList.filter { $0.drinkId == selectedDrinkId }[0]
        delegate?.drinkSelected(drink: drink)
        dismiss(animated: true)
    }
    
    func setUI() {
        view.backgroundColor = .primaryColor25
        
        view.addSubview(cancelButton)
        view.addSubview(drinkPicker)
        view.addSubview(setButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            cancelButton.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        drinkPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drinkPicker.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 0),
            drinkPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            drinkPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            drinkPicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        setButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            setButton.widthAnchor.constraint(equalToConstant: 70),
            setButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            setButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
}

extension DrinkModalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drinkList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let selectedDrink = drinkList[row]
        let text = Common.getDrinkText(selectedDrink)
        return text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDrinkId = drinkList[row].drinkId
    }
}
