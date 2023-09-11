//
//  DrinkModalViewController.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/06.
//

import UIKit

class DrinkModalViewController: UIViewController {
    
    var viewModel: DrinkModalViewModel
    
    init(viewModel: DrinkModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cancelButton = ModalTextButton(title: "Cancel")
    let doneButton = ModalTextButton(title: "Done")
    let drinkPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        setupAutolayout()
        addTargets()
        configureDrinkPicker()
    }
    
    func addTargets() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    func configureDrinkPicker() {
        drinkPicker.delegate = self
        drinkPicker.dataSource = self
        drinkPicker.selectRow(viewModel.initialRow, inComponent: 0, animated: true)
    }
    
    
    @objc func cancelButtonTapped() {
        viewModel.handleCancelButtonTapped(currentVC: self)
    }
    
    @objc func doneButtonTapped() {
        viewModel.handleDoneButtonTapped(currentVC: self)
    }
}

extension DrinkModalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getTitleForRow(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.handleRowSelection(row)
    }
}

extension DrinkModalViewController: AutoLayoutable {
    func setBackgroundColor() {
        view.backgroundColor = .primaryColor25
    }
   
    func setupAutolayout() {
        view.addSubview(cancelButton)
        view.addSubview(drinkPicker)
        view.addSubview(doneButton)
        
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
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            doneButton.widthAnchor.constraint(equalToConstant: 70),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            doneButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
